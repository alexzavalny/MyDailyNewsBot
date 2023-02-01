

# Telegram Rss Bot

A Ruby-based project that consists of two apps - a Telegram bot that communicates with users and a job that reads RSS feeds and sends updates to users.

## Bot Features

 1. Subscribing to RSS feeds

 2. Viewing subscriptions

 1. Unsubscribing from feeds

## Getting Started

### Install the required dependencies

    bundle install

#### Gems used:

 1. `zeitwerk` for automatic loading
 2. `active-record` for DB ORM
 3. `standalone_migrations` for using migrations without Rails
 4. `feedjira` for reading RSS Feeds
 5. `standard` for automatic linting code
 6. `telegram-bot-ruby` for Telegram operations

### Set up your Telegram bot API key

Create a bot using BotFather in Telegram
Rename app_config.yml.example to app_config.yml
Replace `token` in config/app_config.yml with your bot API key

### Start the bot

    ./run_bot

### Start the job to read RSS feeds and send updates

    ./run_job

## Contributing

We welcome contributions to this project. If you have an idea for a feature or found a bug, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License.