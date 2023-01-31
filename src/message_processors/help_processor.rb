module MessageProcessors
  class HelpProcessor < SimpleReplyProcessor
    def initialize(conversation, loader: Application.instance.loader)
      super(conversation)
      @loader = loader
    end

    def reply_with
      @loader&.reload
      Texts.available_commands
    end
  end
end
