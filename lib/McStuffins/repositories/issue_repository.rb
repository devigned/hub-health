module McStuffins
  module Repositories
    class IssueRepository
      include Elasticsearch::Persistence::Repository

      def initialize(options={})
        index  options[:index] || 'github'
        client Elasticsearch::Client.new url: options[:url], log: options[:log]
      end

      klass McStuffins::Models::Issue

      # settings number_of_shards: 5 do
      # end
    end
  end
end