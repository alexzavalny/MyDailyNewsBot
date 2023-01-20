module Extensions
  module ArrayExtension
    def map_with_index
      each_with_index.map { |item, index| yield(item, index) }
    end
  end
end

class Array
  include Extensions::ArrayExtension
end
