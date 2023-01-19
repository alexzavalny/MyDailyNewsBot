require 'telegram/bot'
require 'active_record'
require 'feedjira'
require 'httparty'

require './src/config.rb'
require './src/feed.rb' 
require './models/subscription.rb'
require './db/db_connection.rb'
require './src/texts.rb'
require './src/processor_manager.rb'

#ASK_KIM - How to make logging better?
puts "Starting telegram bot"

# Initialize the Telegram bot
Telegram::Bot::Client.run(Config.get_token) do |bot|
  bot.listen do |message|
    ProcessorManager.process(bot, message)
  end
end
