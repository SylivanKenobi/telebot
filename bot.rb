require 'telegram_bot'
require "open-uri"
require 'json'

token ='749626093:AAEoZvrbrULyjEMIsLFT7IpiHAP-DCNy-h0'

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

    message.reply do |reply|
    case command
    when /start/i
      reply.text = "All I can do is rhyme. Sent me a word I'll rhyme it."
    else
      result = ""
      resString = JSON.parse(URI.parse("https://api.datamuse.com/words?rel_rhy=#{message.text}&max=5").read)
      if resString.empty?
        reply.text = "Nothing rhymes with #{message.text}"
        puts "sending #{reply.text.inspect} to @#{message.from.username}"
        reply.send_with(bot)
        break
      end
      resString.each do |i|
        puts i["word"]
        result += i["word"] +  "\n"
      end
      reply.text = "#{result}"
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
