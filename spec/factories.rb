# encoding: utf-8
FactoryGirl.define do
  factory :api_key do
    access_token SecureRandom.hex
  end

  factory :subscription do
    sequence(:name) {|n| "subscription_#{n}"}
    sequence(:rule) {|n| "regexp_#{n}"}
    sequence(:fansub_id) {|n| n}
  end

  factory :user do
    sequence(:name) {|n| "username_#{n}"}
    sequence(:email) {|n| "user.email_#{n}@example.com"}
    sequence(:password) {|n| 'password_#{n}'}
    last_viewed_at 2.days.ago
  end

  factory :bangumi do
    sequence(:title) {|n| "title_#{n}"}
    classfication ["動畫", "ＲＡＷ", "漫畫", "動漫音樂", "日劇", "其他"].sample
    sequence(:magnet_link) {|n| "magnet:?xt=urn:btih:MAGNET#{n}%2Fannounce"}
    sequence(:upload_at) {|n| (30 - n).minutes.ago}
    sequence(:fansub) {|n| "fansub_#{n}"}
    sequence(:fansub_id)
    size "300MB"
  end
end
