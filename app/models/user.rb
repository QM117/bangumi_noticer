# encoding: utf-8

class User < ActiveRecord::Base
  include ActiveModel::Validations

  after_create :create_api_key

  validates :email, presence: true
  validates :name, presence: true
  validates :password, length: {minimum: 8}, confirmation: true, allow_blank: false, :if => :password_digest_changed?

  has_secure_password
	has_and_belongs_to_many :subscriptions
  has_one :api_key, dependent: :destroy

  def subscribe? bangumi
  	self.subscriptions.each do |subscription|
  		return true if Regexp.new(subscription.rule).match bangumi
  	end
  	return false
  end

  def refresh_access_token!
    self.api_key = ApiKey.create
  end

  private
    def create_api_key
      ApiKey.create user: self
    end
end
