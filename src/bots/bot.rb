require "telegram/bot"
require "active_record"
require "feedjira"
require "httparty"

module Bots
  class Bot
    def initialize(
      client_klass: Telegram::Bot::Client,
      message_processor: ProcessorManager,
      logger: BotLogger.new
    )
      @bot = client_klass.new(Config.token)
      @message_processor = message_processor
      @logger = logger
    end

    def start
      @logger.info("Starting telegram bot")

      @bot.listen do |message|
        @logger.info(message.text)
        @message_processor.process(@bot, message)
      end
    end
  end
end

# ASK_KIM - How to make logging better?
# ASK_KIM - how to remove the dependency on the telegram bot? How to test this all?
