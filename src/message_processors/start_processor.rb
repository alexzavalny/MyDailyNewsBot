module MessageProcessors
  class StartProcessor < BaseProcessor
    def process
      send_text(Texts.welcome)
    end
  end
end
