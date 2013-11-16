# coding: utf-8
require 'rubygems'
require 'active_support/all'
require 'twitter'
require_relative 'twitter_bot/configuration' # 別途自分で用意

class Follow
  include TwitterBot
  SEARCH_WORDS = '#中野梓生誕祭'
  SEARCH_COUNT = 200
  FOLLOW_COUNT = 50

  Twitter.configure do |config|
    config.consumer_key       = Configuration.consumer_key
    config.consumer_secret    = Configuration.consumer_secret
  end

  dignikjp = Twitter::Client.new(
    oauth_token: Configuration.access_token,
    oauth_token_secret: Configuration.oauth_token_secret
  )

  friends = Twitter.friends(Configuration.bot_id)
  # friends = dignikjp.friends
  friend_ids = friends.map(&:id)

  follow_count = 0
  Twitter.search("#{SEARCH_WORDS} -rt", lang: 'ja', result_type: 'recent', count: SEARCH_COUNT).results.map do |status|
    unless friend_ids.include?(status.id)
      dignikjp.follow(status.id)
      count += 1
      sleep 3
    end
    break if follow_count > FOLLOW_COUNT
  end
end
