class BotLogger
  def initialize(logger = Logger.new(STDOUT))
    @logger = logger
  end

  def info(message)
    @logger.info(message)
  end
end
