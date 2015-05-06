require 'ostruct'

module McStuffins
  module CLI
    class Collect < ExitingThor
      desc 'github', 'Gather GitHub data from specified repos or all repos'
      option :repos, alias: '-r', type: 'array', desc: 'Comma separated list of repos to act on (defaults to .mcstuffins.yaml repos)'
      option :state, alias: '-s', type: 'string', default: 'all', desc: 'Issue state to query: open, closed, all'

      def github
        thor(:setup) if !McStuffins::Config.exists? && !options['repos']

        setup_index(force: true)

        repos = options[:tags] || McStuffins::Config.dot_config['repos']
        state = options[:state]

        issues = repos.map do |repo|
          octokit.issues(repo, state: state, per_page: 100).map do |issue|
            hash = issue.to_hash
            hash['repository'] = repo
            hash.delete(:comments)
            McStuffins::Models::Issue.new(hash)
          end
        end.flatten
        say "Read #{issues.count} issues from GitHub"

        issues_by_url = Hash[*issues.collect { |issue| [issue.url, issue] }.flatten]

        comments = repos.map do |repo|
          octokit.issues_comments(repo, per_page: 100).map do |comment|
            hash = comment.to_hash
            McStuffins::Models::Comment.new(hash)
          end
        end.flatten

        say "Read #{comments.count} comments from GitHub"

        comments.each do |comment|
          if issues_by_url.key?(comment.issue_url)
            if issues_by_url[comment.issue_url].comments
              issues_by_url[comment.issue_url].comments.push(comment)
            else
              issues_by_url[comment.issue_url].comments = [comment]
            end
          end
        end

        issues.each do |i|
          i.save
        end

      end

      private

      def setup_index(options = {})
        Elasticsearch::Persistence.client Elasticsearch::Client.new(host: es_host)
        client = McStuffins::Models::Issue.gateway.client
        index_name = McStuffins::Models::Issue.index_name

        client.indices.delete index: index_name rescue nil if options[:force]

        settings = McStuffins::Models::Issue.settings.to_hash
        mappings = McStuffins::Models::Issue.mappings.to_hash

        issue_props = mappings[:issue][:properties]
        issue_props[:user] = McStuffins::Models::User.mappings.to_hash[:user]
        issue_props[:labels] = McStuffins::Models::Label.mappings.to_hash[:label]
        issue_props[:comments] = McStuffins::Models::Comment.mappings.to_hash[:comment]
        issue_props[:comments][:properties][:user] = McStuffins::Models::User.mappings.to_hash[:user]

        client.indices.create index: index_name,
                              body: {
                                  settings: settings,
                                  mappings: mappings
                              }
      end

      def es_host
        McStuffins::Config.dot_config['elasticsearch'] && McStuffins::Config.dot_config['elasticsearch']['host']
      end

      def octokit
        if McStuffins::Config.dot_config['user'] && McStuffins::Config.dot_config['user']['token']
          Octokit::Client.new(access_token: McStuffins::Config.dot_config['user']['token'])
        else
          Octokit::Client.new
        end
      end
    end

  end
end