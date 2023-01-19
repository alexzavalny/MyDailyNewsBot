module MessageProcessors
  class HelpProcessor < BaseProcessor
    def process
      @conversation.reply(Texts.available_commands)
    end
  end
end
