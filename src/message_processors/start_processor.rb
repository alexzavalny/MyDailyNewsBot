module MessageProcessors
  class StartProcessor < BaseProcessor
    def compose_reply
      Texts.welcome
    end
  end
end
