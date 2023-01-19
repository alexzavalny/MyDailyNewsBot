class String
  def integer?
    self.to_i.to_s == self
  end
end

class Array
  def map_with_index
    self.each_with_index.map { |item, index| yield(item, index) }
  end
end
