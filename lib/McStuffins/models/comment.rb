module McStuffins
  module Models
    class Comment
      include Elasticsearch::Persistence::Model
    end
  end
end