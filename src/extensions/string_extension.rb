module Extensions
  module StringExtension
    def integer?
      to_i.to_s == self
    end

    def is_url?
      uri = URI.parse(self)
      %w[http https].include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end
  end
end

class String
  include Extensions::StringExtension
end
