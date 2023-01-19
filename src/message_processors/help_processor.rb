module MessageProcessors
  class HelpProcessor < BaseProcessor
    def compose_reply
      Texts.available_commands
    end
  end
end
