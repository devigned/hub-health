module McStuffins
  module Models
    module RecursiveToHash
      def to_hash
        h = {}
        attributes.each do |key, value|
          h[key] = if self[key].respond_to? :to_hash
                     self[key].to_hash
                   else
                     value
                   end
        end
        h
      end
    end
  end
end
