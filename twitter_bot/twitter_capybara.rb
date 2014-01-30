# coding: utf-8
require 'rubygems'
require 'active_support/all'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

module TwitterCapybara
  include Capybara::DSL
  class Bot

    Capybara.configure do |config|
      config.match = :one
      config.exact_options = true
      config.ignore_hidden_elements = true
      config.visible_text_only = true
    end

    Capybara.run_server = false
    Capybara.default_driver = :selenium
    Capybara.javascript_driver = :poltergeist_debug
    Capybara.ignore_hidden_elements = true

    LOGIN_URL = 'https://twitter.com/login'
    HOME_URL = 'https://twitter.com/'

    # ログインフォームについての処理
    def self.login(screen_name, password)
      Capybara.visit(LOGIN_URL)

      # screen_nameとパスワードを自動入力
      Capybara.find('.js-username-field').set screen_name
      Capybara.find('.js-password-field').set password

      # ログインボタンを探してクリック
      Capybara.find('.submit').click
    end

    # 検索フォームについての処理
    def self.search(words)
      Capybara.visit(HOME_URL)

      # 検索ワードを自動入力
      Capybara.find('#search-query').set words
      # 検索ボタンを探してクリック
      Capybara.find('.js-search-action').find('.nav-search').click
      sleep 3
      # すべてを探してクリック
      Capybara.find('.js-timeline-title').find('.js-nav').click
      # Capybara.find('.toggle-item-2').click
      sleep 3
    end

    def self.follow(count)
      i = 0
      follow_count = 0
      while true
        break if follow_count > count
        tweet = Capybara.first("#stream-items-id").all('li.js-stream-item')[i].try(:first, '.js-stream-tweet')
        if tweet.present? && tweet['data-you-follow'] != 'true'
          tweet.try(:first, '.content').try(:first, '.stream-item-header').try(:first, '.js-user-profile-link').try(:click)
          sleep (2 + rand(3))
          content = Capybara.first('#profile_popup').first('#profile_popup-dialog').first('.modal-content')
          # content.first('.modal-body').first('.profile-header').first('.profile-banner-footer').first('.default-footer').first('.UserActions').first('.not-following').try(:first, '.js-follow-btn').try(:click)
          sleep (5 + rand(10))
          follow_count += 1
          content.first('.js-close').click
        end
        i += 1
      end
    end

    def self.unfollow(screen_name)
      Capybara.visit("#{HOME_URL}#{screen_name}")
      sleep 3
      username = Capybara.first('.profile-page-header').first('.profile-header-inner').first('.profile-card-inner').first('h2.username')
      if username.present? && username.first('.follow-status').blank?
        Capybara.first('.profile-page-header').first('.profile-banner-footer').first('.default-footer').first('.UserActions').first('.following').try(:first, '.js-follow-btn').try(:click)
        sleep (5 + rand(10))
        return true
      else
        sleep (5 + rand(10))
        return false
      end
    end
  end
end
