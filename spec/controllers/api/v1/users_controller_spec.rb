require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "show function" do
    it "should return valid user data" do
      get :show, {name: @user.name, email: @user.email, id: 1}
      expect(response.status).to be 200
      data = JSON.parse(response.body)
      expect(data["data"]["id"]).to eq(@user.id)
      expect(data["data"]["name"]).to eq(@user.name)
      expect(data["data"]["email"]).to eq(@user.email)
    end

    it "should return 401 unless user login" do
      get :show, {name: @user.name, id: 1}
      expect(response.status).to be 401
    end

    it "should return 400 without id" do
      expect {
        get :show, {name: @user.name, email: @user.email}
      }.to raise_error(ActionController::UrlGenerationError)
    end

    it "should return 404 with invalid id" do
      get :show, {name: @user.name, email: @user.email, id: 4096}
      expect(response.status).to be 404
    end
  end

  describe "create function" do
  end
end
