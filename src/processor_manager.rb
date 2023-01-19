# freeze_string_literal: true
require "./src/message_processors/base_processor"
Dir["./src/message_processors/*.rb"].sort.each do |file|
  puts "Loading #{file}"
  require file
end

# This class is responsible for mapping commands to processors
# and executing the right processor for the command
# ASK_KIM - Should this be a module? Should this file be here? How should it be called?
class ProcessorManager
  PROCESSORS_MAPPING = {
    "/start" => MessageProcessors::StartProcessor,
    "/list_subscriptions" => MessageProcessors::ListSubscriptionsProcessor,
    "/subscribe" => MessageProcessors::SubscribeProcessor,
    "/unsubscribe" => MessageProcessors::UnsubscribeProcessor,
    "/help" => MessageProcessors::HelpProcessor,
    "/catalog" => MessageProcessors::CatalogProcessor
  }.freeze

  class << self
    def process(bot, message)
      self.get_processor(bot, message).process
    end

    def get_processor(bot, message)
      (PROCESSORS_MAPPING[message.text] || MessageProcessors::UnknownCommandProcessor).new(bot, message)
    end
  end
end
