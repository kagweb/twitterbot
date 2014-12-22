# coding: utf-8
require 'rubygems'
require 'active_support'
require 'twitter'
require_relative 'twitter_bot/configuration' # 別途自分で用意
require_relative 'twitter_bot/twitter_capybara'

class List
  include TwitterBot
  include TwitterCapybara

  SEARCH_WORDS = '#アニメ好きな人RT'
  LIST_WORD = 'アニメ好きなクラスタ'
  SEARCH_COUNT = 200
  LIST_IN_COUNT = 3

  Bot.login(Configuration.bot_screen_name, Configuration.bot_password)
  Bot.search("#{SEARCH_WORDS} #RTした人全員フォローする -RT -#相互 -#相互希望 -#相互限定 -#相互フォロー")
  Bot.list_in(count = LIST_IN_COUNT, word = LIST_WORD)

  puts 'list in task done!'
end
