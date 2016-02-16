# encoding: utf-8

class Bangumi < ActiveRecord::Base
  include ActiveModel::Validations

  has_and_belongs_to_many :subscriptions
  validates :title, presence: true
  # validations :classfication, exclusion: {in: %w(動畫 動漫音樂 電腦遊戲 ＲＡＷ 特攝 日劇 季度全集)}
  # TODO: 待确认是否遗漏
end