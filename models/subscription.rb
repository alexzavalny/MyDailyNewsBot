require "active_record"

class Subscription < ActiveRecord::Base
  default_scope { order(created_at: :asc) }

  def name_with_url
    "#{website_name} (#{feed_url})"
  end
end
