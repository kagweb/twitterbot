# coding: utf-8

# gem install activesupport
# gem install twitter
# gem install capybara
# gem install poltergeist
# gem install selenium
# gem install selenium-webdriver
# and install phantomjs

require 'rubygems'
require 'active_support/all'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require "selenium/webdriver"
require 'pp'

module TwitterCapybara
  include Capybara::DSL
  class Bot

    Capybara.configure do |config|
      config.match = :one
      config.exact_options = true
      config.ignore_hidden_elements = true
      config.visible_text_only = true
    end

    Capybara.register_driver :poltergeist do |app|
      driver = Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 10000, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=any'])
    end

    Capybara.run_server = false
    # Capybara.default_driver = :selenium
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.ignore_hidden_elements = true

    HOME_URL = 'https://twitter.com/'
    LOGIN_URL = "#{HOME_URL}login"

    # ログインフォームについての処理
    def self.login(screen_name, password)
      Capybara.visit(LOGIN_URL)

      # screen_nameとパスワードを自動入力
      Capybara.find('.js-username-field').set screen_name
      Capybara.find('.js-password-field').set password

      # ログインボタンを探してクリック
      Capybara.find('.submit').click
      puts 'logged in!'
    end

    # 検索フォームについての処理
    def self.search(words)
      puts "search start : #{words}"
      Capybara.visit(HOME_URL)
      sleep 3
      # 検索ワードを自動入力
      Capybara.find('#search-query').set words
      # 検索ボタンを探してクリック
      Capybara.find('.js-search-action').find('.nav-search').click
      sleep 3
      # すべてを探してクリック
      Capybara.find('.js-timeline-title').find('.js-nav').click
      # Capybara.find('.toggle-item-2').click
      sleep 3
      puts 'search done!'
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
          content.first('.modal-body').first('.profile-header').first('.profile-banner-footer').first('.default-footer').first('.UserActions').first('.not-following').try(:first, '.js-follow-btn').try(:click)
          puts 'follow!'
          sleep (5 + rand(10))
          follow_count += 1
          content.first('.js-close').click
        else
          puts 'not follow'
          sleep (5 + rand(10))
        end
        i += 1
      end
    end

    def self.unfollow(screen_name)
      Capybara.visit("#{HOME_URL}#{screen_name}")
      sleep (2 + rand(3))
      username = Capybara.first('.profile-page-header').first('.profile-header-inner').first('.profile-card-inner').first('h2.username')
      if username.present? && username.first('.follow-status').blank?
        Capybara.first('.profile-page-header').first('.profile-banner-footer').first('.default-footer').first('.UserActions').first('.following').try(:first, '.js-follow-btn').try(:click)
        puts 'unfollow!'
        sleep (5 + rand(10))
        return true
      else
        puts 'not unfollow'
        sleep (5 + rand(10))
        return false
      end
    end

    def self.list_in(count, list_name)
      i = 0
      list_in_count = 0
      created = false
      while true
        break if list_in_count > count
        tweet = Capybara.first("#stream-items-id").all('li.js-stream-item')[i].try(:first, '.js-stream-tweet')
        if tweet.present? && tweet['data-you-follow'] != 'true'
          tweet.try(:first, '.content').try(:first, '.stream-item-header').try(:first, '.js-user-profile-link').try(:click)
          sleep (2 + rand(3))
          dropdown = Capybara.first('#profile_popup-body').first('.UserActions-moreActions').first('.user-dropdown').try(:click)
          sleep (2 + rand(3))
          Capybara.first('.list-text').try(:click)
          sleep (2 + rand(3))

          # リストが無ければ作成
          if !(created || Capybara.find('ul.list-membership-container').find('li', text: list_name).present?)
            list_content = Capybara.first('.create-a-list').try(:click)
            sleep (2 + rand(3))
            Capybara.first('#list-name').set list_name
            Capybara.first('.update-list-button').try(:click)
            puts "create #{list_name} list!"
          end
          created = true

          # リスト登録
          list = Capybara.find('ul.list-membership-container').find('li', text: list_name)
          if list.text == list_name && !(list.find('.membership-checkbox')['checked'] == 'true' || list.find('.membership-checkbox')['checked'] == true)
            list.find('.membership-checkbox').try(:click)
            puts "list in #{list_name}!"
          end
          sleep (5 + rand(10))
          list_in_count += 1
          Capybara.first('.js-close').click
        else
          puts 'not list in'
          sleep (5 + rand(10))
        end
        i += 1
      end
    end
  end
end
