module MessageProcessors
  # ASK_KIM - seems like this base class also is like a wrapper for bot (telegram api)...
  class BaseProcessor
    attr_reader :message, :bot

    def initialize(bot, message)
      @bot = bot
      @message = message
    end

    def process
      send_text(compose_reply)
    end

    def compose_reply
      raise NotImplementedError
    end

    # ASK_KIM -- is this good idea?
    def send_text(reply)
      bot.api.send_message(chat_id: @message.chat.id, text: reply)
    end
  end
end
