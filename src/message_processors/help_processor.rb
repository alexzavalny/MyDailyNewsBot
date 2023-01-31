module MessageProcessors
  class HelpProcessor < SimpleReplyProcessor
    def reply_with
      Texts.available_commands
    end
  end
end
