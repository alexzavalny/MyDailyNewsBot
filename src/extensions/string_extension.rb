module Extensions
  module StringExtension
    def integer?
      to_i.to_s == self
    end
  end
end

class String
  include Extensions::StringExtension
end
