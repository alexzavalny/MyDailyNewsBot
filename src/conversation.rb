require 'forwardable'

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
