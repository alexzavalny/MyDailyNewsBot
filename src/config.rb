module Config
  CONFIG_FILE_NAME = "./config/app_config.yml"

  def self.token
    app_config["token"]
  end

  def self.subscription_limit
    app_config["subscription_limit"].to_i
  end

  def self.sleep_time

    app_config["job_sleep_cycle"].to_i
  end

  def self.app_config
    YAML.load_file(CONFIG_FILE_NAME)
  end
end
