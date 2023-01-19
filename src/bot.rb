require "telegram/bot"
require "active_record"
require "feedjira"
require "httparty"

require "./src/config"
require "./src/feed"
require "./models/subscription"
require "./db/db_connection"
require "./src/texts"
require "./src/processor_manager"

# ASK_KIM - How to make logging better?
puts "Starting telegram bot"

# Initialize the Telegram bot
Telegram::Bot::Client.run(Config.token) do |bot|
  bot.listen do |message|
    ProcessorManager.process(bot, message)
  end
end
