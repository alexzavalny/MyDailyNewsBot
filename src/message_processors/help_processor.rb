#freeze_string_literal: true

module MessageProcessors
  class HelpProcessor < BaseProcessor
    def process
      send_text(Texts.available_commands)
    end
  end
end