require_relative 'user'
require_relative 'label'

module McStuffins
  module Models
    class Issue
      include Elasticsearch::Persistence::Model

      index_name 'github-issues'

      attribute :repository,    String,         mapping: {type: 'string', index: 'not_analyzed'}
      attribute :url,           String
      attribute :labels_url,    String
      attribute :comments_url,  String
      attribute :events_url,    String
      attribute :html_url,      String
      attribute :id,            Integer
      attribute :number,        Integer
      attribute :title,         String
      attribute :state,         String,         mapping: {type: 'string', index: 'not_analyzed'}
      attribute :locked,        Boolean
      attribute :assignee,      String
      attribute :milestone,     String
      attribute :created_at,    DateTime
      attribute :updated_at,    DateTime
      attribute :closed_at,     DateTime
      attribute :body,          String
      attribute :user,          User
      attribute :labels,        Array[Label]
      attribute :comments,      Array[Comment]
    end
  end
end