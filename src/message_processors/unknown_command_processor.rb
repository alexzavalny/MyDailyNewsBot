module MessageProcessors
  class UnknownCommandProcessor < SimpleReplyProcessor
    def reply_with
      Texts.unknown_command
    end
  end
end
