# encoding: utf-8

class User < ActiveRecord::Base
	include ActiveModel::Validations

	validates :email, presence: true
	validates :name, presence: true

	has_and_belongs_to_many :subscriptions

  def subscribe? bangumi
  	self.subscriptions.each do |subscription|
  		return true if Regexp.new(subscription.rule).match bangumi
  	end
  	return false
  end
end
