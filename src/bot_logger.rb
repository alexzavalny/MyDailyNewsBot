class BotLogger
  def initialize(logger = Logger.new($stdout))
    @logger = logger
  end

  def info(message)
    @logger.info(message)
  end
end
