class String
  def integer?
    self.to_i.to_s == self
  end
end
