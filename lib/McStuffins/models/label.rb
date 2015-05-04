module McStuffins
  module Models
    class Label
      include Elasticsearch::Persistence::Model
      include Base

      attribute :url,     String
      attribute :name,    String
      attribute :color,   String
    end
  end
end
