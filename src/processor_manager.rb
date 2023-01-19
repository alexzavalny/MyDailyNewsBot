require "./src/conversation"

Dir["./src/message_processors/*.rb"].sort.each do |file|
  puts "Loading #{file}"
  require file
end
# TODO: zeitwerk

# This class is responsible for mapping commands to processors
# and executing the right processor for the command
# ASK_KIM - Should this file be here? How should it be called?
class ProcessorManager
  DEFAULT = MessageProcessors::UnknownCommandProcessor

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
      conversation = Conversation.new(bot: bot, message: message)
      self.processor_for_conversation(conversation).process
    end

    def processor_for_conversation(conversation)
      (PROCESSORS_MAPPING[conversation.command] || DEFAULT).new(conversation)
    end
  end
end
