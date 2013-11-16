# coding: utf-8
require 'twitter'
require './config.rb' # 別途自分で用意

class Follow
  Twitter.configure do |config|
    config.consumer_key       = Config.consumer_key
    config.consumer_secret    = Config.consumer_secret
    config.oauth_token        = Config.access_token
    config.oauth_token_secret = Config.oauth_token_secret
  end
end
