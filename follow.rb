# coding: utf-8
require 'rubygems'
require 'active_support/all'
require 'twitter'
require_relative 'twitter_bot/configuration' # 別途自分で用意

class Follow
  include TwitterBot
  SEARCH_WORDS = '#アニメ好きな人RT'
  SEARCH_COUNT = 200
  FOLLOW_COUNT = 50

  Twitter.configure do |config|
    config.consumer_key       = Configuration.consumer_key
    config.consumer_secret    = Configuration.consumer_secret
  end

  client = Twitter::Client.new(
    oauth_token: Configuration.access_token,
    oauth_token_secret: Configuration.oauth_token_secret
  )

  begin
    friend_ids = Twitter.friends(Configuration.bot_id).map(&:id)
    # friend_ids = client.friends.map(&:id) # 多分API重い…？
    follow_count = 0
    Twitter.search("#{SEARCH_WORDS} -rt", lang: 'ja', result_type: 'recent', count: SEARCH_COUNT).results.map do |status|
      begin
        unless friend_ids.include?(status.user.id)
          client.follow(status.user.id)
          follow_count += 1
          sleep 5
          puts "Follow #{status.id}"
        end
        break if follow_count > FOLLOW_COUNT
      rescue Twitter::Error::NotFound
      end
    end
  rescue Twitter::Error::TooManyRequests
    puts 'Too many requests. Just a moment please.'
  end
end
