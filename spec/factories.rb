# encoding: utf-8
FactoryGirl.define do
  factory :subscription do
    sequence(:name) {|n| "subscription_#{n}"}
    sequence(:rule) {|n| "regexp_#{n}"}
  end

  factory :user do
    sequence(:name) {|n| "username_#{n}"}
    sequence(:email) {|n| "user.email_#{n}@example.com"}
  end

end
