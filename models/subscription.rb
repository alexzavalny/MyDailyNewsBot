require "active_record"

class Subscription < ActiveRecord::Base
  default_scope { order(created_at: :desc) }
end
