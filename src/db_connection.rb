# Connect to the database using Active Record
require "active_record"

class DbConnection
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: "db/development.sqlite3"
    )
  end
end
