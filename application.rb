require "zeitwerk"
require "singleton"

class Application
  include Singleton

  attr_reader :loader

  def initialize
    initialize_loader
  end

  def initialize_loader
    @loader = Zeitwerk::Loader.new

    @loader.push_dir("#{__dir__}/models")
    @loader.push_dir("#{__dir__}/src")
    @loader.enable_reloading
    @loader.setup
    @loader.eager_load_dir("#{__dir__}/src/extensions")
  end

  def run_bot
    Bots::RssBot.new.start
  end
end
