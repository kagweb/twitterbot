# coding: utf-8
require 'rubygems'
require 'active_support/all'
require 'twitter'
require_relative 'twitter_bot/configuration' # 別途自分で用意
require_relative 'twitter_bot/twitter_capybara'

class UnFollow
  include TwitterBot
  include TwitterCapybara

  UNFOLLOW_COUNT = 10

  Twitter.configure do |config|
    config.consumer_key       = Configuration.consumer_key
    config.consumer_secret    = Configuration.consumer_secret
  end

  begin
    friends = Twitter.friends(Configuration.bot_id)
    screen_names = [] # ["kag_web", "Ryohlan", "watkc", "takumi_lost", "yuha_yuhan"]
    friends.users.reverse.map { |friend| screen_names << friend.screen_name if friend.following.nil? }
    puts 'get screen names!'
  rescue Twitter::Error::TooManyRequests
    puts 'Too many requests. Just a moment please.'
  end

  Bot.login(Configuration.bot_screen_name, Configuration.bot_password)

  unfollow_count = 0
  screen_names.each do |screen_name|
    unfollow_count += 1 if Bot.unfollow(screen_name)
    break if unfollow_count > UNFOLLOW_COUNT
  end
  puts 'unfollow task done!'
 end
