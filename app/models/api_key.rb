class ApiKey < ActiveRecord::Base
  belongs_to :user
  before_create :generate_access_token
  before_create :set_expires

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def expired?
    DateTime.now > self.expires_at
  end

  def set_expires
    self.expires_at = DateTime.now + 30.days
  end
end
