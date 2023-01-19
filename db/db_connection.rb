# Connect to the database using Active Record
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/development.sqlite3"
)
