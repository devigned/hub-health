module McStuffins
  module Models
    class Label
      include Elasticsearch::Persistence::Model

      attribute :url,     String
      attribute :name,    String,         mapping: {type: 'string', index: 'not_analyzed'}
      attribute :color,   String,         mapping: {type: 'string', index: 'not_analyzed'}
    end
  end
end
