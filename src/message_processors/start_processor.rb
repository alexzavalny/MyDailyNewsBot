module MessageProcessors
  class StartProcessor < BaseProcessor
    def process
      @conversation.reply(Texts.welcome)
    end
  end
end
