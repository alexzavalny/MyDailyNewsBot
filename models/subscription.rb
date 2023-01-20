require "active_record"

DbConnection.connect

class Subscription < ActiveRecord::Base
  default_scope { order(created_at: :asc) }

  def name_with_url
    "#{website_name} (#{feed_url})"
  end

  def self.reached(chat_id:, count:)
    where(chat_id: chat_id).count >= count
  end
end
