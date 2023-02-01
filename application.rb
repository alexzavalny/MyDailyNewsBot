require "zeitwerk"
require "singleton"

class Application
  include Singleton

  attr_reader :loader

  DIRECTORIES_TO_LOAD = [
    "#{__dir__}/models",
    "#{__dir__}/src",
  ].freeze

  DIRECTORIES_TO_EAGER_LOAD = [
    "#{__dir__}/src/extensions",
  ].freeze

  def initialize
    initialize_loader
  end

  def initialize_loader
    @loader = Zeitwerk::Loader.new

    DIRECTORIES_TO_LOAD.each do |dir|
      @loader.push_dir(dir)
    end

    @loader.enable_reloading
    @loader.setup

    DIRECTORIES_TO_EAGER_LOAD.each do |dir|
      @loader.eager_load_dir(dir)
    end
  end

  def run_bot
    Bots::RssBot.new.start
  end

  def run_job
    Jobs::SubscriptionJob.new.start
  end
end
