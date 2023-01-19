module MessageProcessors
  class UnknownCommandProcessor < BaseProcessor
    def compose_reply
      Texts.unknown_command
    end
  end
end
