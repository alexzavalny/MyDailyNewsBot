module MessageProcessors
  class BaseProcessor
    attr_reader :conversation

    def initialize(conversation)
      @conversation = conversation
    end

    def process
      raise NotImplementedError
    end
  end
end
