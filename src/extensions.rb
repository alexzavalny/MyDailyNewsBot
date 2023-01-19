class String
  def integer?
    to_i.to_s == self
  end
end

class Array
  def map_with_index
    each_with_index.map { |item, index| yield(item, index) }
  end
end
