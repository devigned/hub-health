module McStuffins
  module CLI
    class Status < ExitingThor

      desc 'github', 'Display GitHub API status'
      def github
        rate = octokit.rate_limit
        say "Your rate limit is #{rate.limit}, you have #{rate.remaining} remaining." +
            " You will get more in #{rate.resets_in} seconds."
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
