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
  LIST_NAME = 'アニメ好きなクラスタ'
  # SEARCH_WORD = '萩原雪歩'
  # SEARCH_WORDS = "(\##{SEARCH_WORD}誕生祭 OR \##{SEARCH_WORD}生誕祭 OR \##{SEARCH_WORD}誕生祭2014 OR \##{SEARCH_WORD}生誕祭2014)"
  # LIST_NAME = '雪歩クラスタ'
  SEARCH_COUNT = 200
  LIST_IN_COUNT = 20

  Bot.login(Configuration.bot_screen_name, Configuration.bot_password)
  Bot.search("#{SEARCH_WORDS} #RTした人全員フォローする -RT -#相互 -#相互希望 -#相互限定 -#相互フォロー")
  Bot.list_in(count = LIST_IN_COUNT, list_name = LIST_NAME)

  puts 'list in task done!'
end
