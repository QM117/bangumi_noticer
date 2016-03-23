class Subscription < ActiveRecord::Base
	has_and_belongs_to_many :users
  has_and_belongs_to_many :bangumis

  def match? bangumi
    if self.fansub_id == bangumi.fansub_id
      Regexp.new(self.rule).match bangumi.title
    else
      false
    end
  end
end
