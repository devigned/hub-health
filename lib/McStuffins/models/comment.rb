require_relative 'user'

module McStuffins
  module Models
    class Comment
      include Elasticsearch::Persistence::Model

      attribute :url,         String
      attribute :html_url,    String
      attribute :issue_url,   String
      attribute :id,          Integer
      attribute :user,        User
      attribute :created_at,  DateTime
      attribute :updated_at,  DateTime
      attribute :body,        String
    end
  end
end