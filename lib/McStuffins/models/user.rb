module McStuffins
  module Models
    class User
      include Elasticsearch::Persistence::Model
      include Base

      attribute :login,               String
      attribute :id ,                 Integer
      attribute :avatar_url,          String
      attribute :gravatar_id,         String
      attribute :url,                 String
      attribute :html_url,            String
      attribute :followers_url,       String
      attribute :following_url,       String
      attribute :gists_url,           String
      attribute :starred_url,         String
      attribute :subscriptions_url,   String
      attribute :organizations_url,   String
      attribute :repos_url,           String
      attribute :events_url,          String
      attribute :received_events_url, String
      attribute :type,                String
      attribute :site_admin,          Boolean
    end
  end
end
