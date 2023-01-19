require "telegram/bot"
require "active_record"
require "feedjira"
require "httparty"

require "./src/config"
require "./src/feed_utils"
require "./models/subscription"
require "./db/db_connection"
require "./src/texts"
require "./src/processor_manager"
require "./src/extensions"

# ASK_KIM - How to make logging better?
puts "Starting telegram bot"

# Initialize the Telegram bot
# ASK_KIM - how to remove the dependency on the telegram bot? How to test this all?
Telegram::Bot::Client.run(Config.token) do |bot|
  bot.listen do |message|
    p message.text
    ProcessorManager.process(bot, message)
  end
end
