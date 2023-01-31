module MessageProcessors
  class SimpleReplyProcessor < BaseProcessor
    def process
      @conversation.reply(reply_with)
    end

    private

    def reply_with
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end
  end
end
