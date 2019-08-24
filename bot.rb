require 'telegram_bot'
require "open-uri"
require 'json'
require 'csv'

token ='961383937:AAE4iNclJMUyzkEmZjcF8aWaTFuz-PXuc4U'

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    case command
    when command
      data = CSV.parse(message.text)
      resString = JSON.parse(URI.parse("https://api.datamuse.com/words?rel_rhy=#{data[0][0]}&max=#{data[0][1]}").read)
      puts message.text
      reply.text = "#{resString}"
    else
      reply.text = "I have no idea what #{command.inspect} means."
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
