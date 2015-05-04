require 'ostruct'

module McStuffins
  module CLI
    class Collect < ExitingThor
      desc 'github', 'Gather GitHub data from specified repos or all repos'
      option :repos, alias: '-r', type: 'array', desc: 'Comma separated list of repos to act on (defaults to .mcstuffins.yaml repos)'
      option :state, alias: '-s', type: 'string', default: 'all', desc: 'Issue state to query: open, closed, all'

      def github
        thor(:setup) if !McStuffins::Config.exists? && !options['repos']

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
        say issues.count

        issues_by_url = Hash[*issues.collect { |issue| [issue.url, issue] }.flatten]

        comments = repos.map do |repo|
          octokit.issues_comments(repo, per_page: 100).map do |comment|
            hash = comment.to_hash
            McStuffins::Models::Comment.new(hash)
          end
        end.flatten

        say comments.count

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