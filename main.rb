require 'discordrb'
require 'nokogiri'
require 'open-uri'

config = File.foreach('config.txt').map { |line| line.split(' ').join(' ') }
token = config[0].to_s
client_id = config[1].to_s
prefix = config[2].to_s

bot = Discordrb::Commands::CommandBot.new token: "#{token}", client_id: "#{client_id}", prefix: "#{prefix}"

bot.command :user do |event| # template, returns username
    event.user.name
end

bot.command :bold do |event, *words|
    "**#{words.join(' ')}**"
end
  
bot.command :italic do |event, *words|
    "*#{words.join(' ')}*"
end

bot.command :search do |event, *terms|
    terms = "*#{terms.join('+')}*"
    url = "https://www.google.com/search?q=#{terms}&hl=en&tbm=isch"
    doc = Nokogiri::HTML(URI.open(url).read)
    pics = doc.search('img').map(&:attributes).map { |node| 
        node['src'].value 
    }
    pics.select { |url| url.match(/https/) }
    pics[rand(0..pics.length-1)]   
end

bot.run