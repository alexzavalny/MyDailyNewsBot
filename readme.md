Telegram Rss Bot

A Ruby-based project that consists of two apps - a Telegram bot that communicates with users and a job that reads RSS feeds and sends updates to users.

Bot Features

Subscribing to RSS feeds
Viewing subscriptions
Unsubscribing from feeds
Getting Started

Clone the repository to your local machine
bash
Copy code
git clone https://github.com/YOUR-USERNAME/Telegram-Rss-Bot.git
Install the required dependencies
Copy code
bundle install
Set up your Telegram bot API key
Create a bot using BotFather in Telegram
Replace YOUR_TELEGRAM_BOT_API_KEY in config/secrets.yml with your bot API key
Start the bot
Copy code
rake start_bot
Start the job to read RSS feeds and send updates
Copy code
rake start_job
Contributing

We welcome contributions to this project. If you have an idea for a feature or found a bug, feel free to open an issue or submit a pull request.

License

This project is licensed under the MIT License.