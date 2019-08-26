require 'telegram_bot'
require "open-uri"
require 'json'
require 'csv'

token ='961383937:AAE4iNclJMUyzkEmZjcF8aWaTFuz-PXuc4U'

re1='.*?'	# Non-greedy match on filler
re2='(?:[a-z][a-z]+)'	# Uninteresting: word
re3='.*?'	# Non-greedy match on filler
re4='((?:[a-z][a-z]+))'	# Word 1
re=(re1+re2+re3+re4)
m=Regexp.new(re,Regexp::IGNORECASE);
bot = TelegramBot.new(token: token)
result = ""

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

    message.reply do |reply|
    case command
    when /start/i
      reply.text = "All I can do is rhyme. Sent me a word I'll rhyme it."
    else
      data = CSV.parse(message.text)
      resString = JSON.parse(URI.parse("https://api.datamuse.com/words?rel_rhy=#{data[0][0]}&max=5").read)
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
