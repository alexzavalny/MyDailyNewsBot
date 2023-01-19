module MessageProcessors
  class UnknownCommandProcessor < BaseProcessor
    def process
      @conversation.reply(Texts.unknown_command)
    end
  end
end
