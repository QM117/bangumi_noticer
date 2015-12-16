require 'rails_helper'

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end

  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:mobile_phone)}
  it {should respond_to(:password_digest)}

  describe "when lacking name" do
    before do
      @user = User.new(email: "user.email@example.com")
    end
    it {should_not be_valid}
  end

  describe "when lacking email" do
    before do
      @user = User.new(name: "username")
    end
    it {should_not be_valid}
  end

end
