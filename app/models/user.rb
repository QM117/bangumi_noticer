# encoding: utf-8

class User < ActiveRecord::Base
	include ActiveModel::Validations

	validates :email, presence: true
	validates :name, presence: true

	has_and_belongs_to_many :subscribe_rules

  def subscribe? bangumi
  	self.subscribe_rules.each do |subscribe_rule|
  		return true if Regexp.new(subscribe_rule.name).match bangumi
  	end
  	return false
  end
end
