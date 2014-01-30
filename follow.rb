# coding: utf-8
require 'rubygems'
require 'active_support'
require 'twitter'
require_relative 'twitter_bot/configuration' # 別途自分で用意
require_relative 'twitter_bot/twitter_capybara'

class Follow
  include TwitterBot
  include TwitterCapybara

  SEARCH_WORDS = '#アニメ好きな人RT'
  SEARCH_COUNT = 200
  FOLLOW_COUNT = 3

  Bot.login(Configuration.bot_screen_name, Configuration.bot_password)
  Bot.search("#{SEARCH_WORDS} -rt")
  Bot.follow(FOLLOW_COUNT)
end
