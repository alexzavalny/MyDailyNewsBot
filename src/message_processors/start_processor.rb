module MessageProcessors
  class StartProcessor < SimpleReplyProcessor
    def reply_with
      Texts.welcome
    end
  end
end
