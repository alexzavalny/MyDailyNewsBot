require "forwardable"

class Conversation
  extend Forwardable

  def_delegators :@bot, :listen

  def initialize(bot:, message:)
    @bot = bot
    @message = message
  end

  def reply(text)
    @bot.api.send_message(chat_id: @message.chat.id, text: text)
  end

  def reply_with_keyboard(keyboard)
    @bot.api.send_message(
      chat_id: @message.chat.id,
      text: "Select one of the options below:",
      reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: keyboard, one_time_keyboard: true)
    )
  end

  def command
    @message.text
  end

  def chat_id
    @message.chat.id
  end

  # def prompt
  #   @bot.listen do |message|
  #     break message if message.text
  #   end
  # end
end
