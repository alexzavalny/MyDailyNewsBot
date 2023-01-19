module MessageProcessors
  class UnknownCommandProcessor < BaseProcessor
    def process
      send_text(Texts.unknown_command)
    end
  end
end