require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @user_token = @user.api_key.access_token
    @another_user =FactoryGirl.create(:user)
    @another_user_token = @another_user.api_key.access_token
  end

  describe "show function" do
    it "should return 200 and user data" do
      get :show, {token: @user_token, id: @user.id}
      expect(response.status).to be 200
      data = JSON.parse(response.body)
      expect(data["user"]["id"]).to eq(@user.id)
      expect(data["user"]["name"]).to eq(@user.name)
      expect(data["user"]["email"]).to eq(@user.email)
    end

    it "should return 401 without token" do
      get :show, {id: @user.id}
      expect(response.status).to be 401
    end

    it "should return 400 without id" do
      expect {
        get :show, {token: @user_token}
      }.to raise_error(ActionController::UrlGenerationError)
    end

    it "should return 401 when access profile of others" do
      get :show, {token: @user_token, id: @another_user.id}
      expect(response.status).to be 401
    end

    it "should return 404 with invalid id" do
      get :show, {token: @user_token, id: User.last.id * 3}
      expect(response.status).to be 404
    end
  end

  describe "create function" do
    it "should create a user and return data with valid parameters" do
      post :create, {name: "username", email: "user.email@test.com", password: "password"}
      expect(response.status).to be 201
      data = JSON.parse(response.body)
      user = User.find_by_id(data["user"]["id"])

      expect(user).not_to be_nil
      expect(user.name).to eq("username")
      expect(user.email).to eq("user.email@test.com")
      expect(user.authenticate("password")).not_to be false
    end

    it "should return 400 when lacking parameters" do
      post :create, {name: 'username', email: "user.email@test.com"}
      expect(response.status).to be 400
    end
  end

  describe "subscribe function" do
    before do
      @subscription = FactoryGirl.create(:subscription)
    end

    it "should return 400 without subscription id" do
      post :subscribe, {token: @user_token}
      expect(response.status).to be 400
    end

    it "should return 200 with message 'ok' and associate the current user and the subscription" do
      post :subscribe, {token: @user_token, subscription_id: @subscription.id}
      expect(response.status).to be 200
      expect(JSON.parse(response.body)["message"]).to eq("ok")
      expect(@subscription.users.include? @user).to be true
      expect(@user.subscriptions.include? @subscription).to be true
    end
  end

  describe "unsubscribe function" do
    before do
      @subscription = FactoryGirl.create(:subscription)
      @user.subscriptions << @subscription
      @user.save
    end

    it "should return 400 without subscription id" do
      post :unsubscribe, {token: @user_token}
      expect(response.status).to be 400
    end

    it "should return 200 with message 'ok' and delete the association of current user and the subscription" do
      post :unsubscribe, {token: @user_token, subscription_id: @subscription.id}
      expect(response.status).to be 200
      expect(JSON.parse(response.body)["message"]).to eq("ok")
      expect(@subscription.users.include? @user).to be false
      expect(@user.subscriptions.include? @subscription).to be false
    end
  end
end
