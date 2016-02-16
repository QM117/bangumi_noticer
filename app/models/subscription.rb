class Subscription < ActiveRecord::Base
	has_and_belongs_to_many :users
  has_and_belongs_to_many :bangumis

  def match? bangumi
    Regexp.new(self.rule).match bangumi.title
  end
end
