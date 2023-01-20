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
      processor_for_conversation(conversation).new(conversation).process
    end

    def processor_for_conversation(conversation)
      return MessageProcessors::SubscribeProcessor if conversation.command.is_url?
      (PROCESSORS_MAPPING[conversation.command] || DEFAULT)
    end
  end
end
