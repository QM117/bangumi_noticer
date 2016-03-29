require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @user_token = @user.api_key.access_token
  end

  describe "create function" do
    it "should return 401 without user's token" do
      post :create, {name: "subscription name", rule: "subscription_rule"}
      expect(response.status).to be 401
    end

    it "should create a subscription and return data with valid parameters" do
      post :create, {token: @user_token, name: "subscription name", rule: "subscription_rule", fansub_id: 233}
      expect(response.status).to be 201
      data = JSON.parse(response.body)
      subscription = Subscription.find_by_id(data["subscription"]["id"])

      expect(subscription).not_to be_nil
      expect(subscription.name).to eq("subscription name")
      expect(subscription.rule).to eq("subscription_rule")
      expect(subscription.fansub_id).to eq(233)
    end

    it "should return 400 without valid parameters" do
      post :create, {token: @user_token, name: "subscription name"}
      expect(response.status).to be 400
    end
  end

  describe "index function" do
    before do
      @subscription = FactoryGirl.create(:subscription)
      @subscription_2 = FactoryGirl.create(:subscription)
      @subscription_3 = FactoryGirl.create(:subscription)

      @user.subscriptions << @subscription
      @user.subscriptions << @subscription_2
    end

    it "should return all subscriptions of the current user" do
      get :index, {token: @user_token}
      expect(response.status).to be 200
      data = JSON.parse(response.body)
      expect(data["subscriptions"].length).to be 2
      expect(data["subscriptions"][0]["id"]).to eq @subscription_2.id
      expect(data["subscriptions"][1]["id"]).to eq @subscription.id
    end

    it "should return all subscription with limit" do
      get :index, {token: @user_token, limit: 1}
      expect(response.status).to be 200
      data = JSON.parse(response.body)
      expect(data["subscriptions"].length).to be 1
      expect(data["subscriptions"][0]["id"]).to eq @subscription_2.id
    end

    it "should return all subscriptions with limit 0" do
      get :index, {token: @user_token, limit: 0}
      expect(response.status).to be 200
      data = JSON.parse(response.body)
      expect(data["subscriptions"].length).to be 2
      expect(data["subscriptions"][0]["id"]).to eq @subscription_2.id
      expect(data["subscriptions"][1]["id"]).to eq @subscription.id
    end

    it "should return 401 without user's token" do
      get :index, {limit: 0}
      expect(response.status).to be 401
    end
  end

  describe "show function" do
    before do
      @subscription = FactoryGirl.create(:subscription)
    end

    it "should return 401 without user's token" do
      get :show, {id: @subscription.id}
      expect(response.status).to be 401
    end

    it "should return 200 with valid parameters" do
      get :show, {token: @user_token, id: @subscription.id}
      expect(response.status).to be 200
      data = JSON.parse(response.body)
      expect(data["subscription"]["id"]).to eq @subscription.id
      expect(data["subscription"]["name"]).to eq @subscription.name
      expect(data["subscription"]["rule"]).to eq @subscription.rule
      expect(data["subscription"]["fansub_id"]).to eq @subscription.fansub_id
    end

    it "should not get anything without id" do
      expect {
        get :show, {token: @user_token}
      }.to raise_error(ActionController::UrlGenerationError)
    end

    it "should return 404 with invalid id" do
      get :show, {token: @user_token, id: Subscription.last.id * 3}
      expect(response.status).to be 404
    end
  end

  describe "update function" do
    before do
      @subscription = FactoryGirl.create(:subscription)
    end

    it "should return 401 without access token" do
      put :update, {id: @subscription.id, name: "subscription_new_name"}
      expect(response.status).to be 401
    end

    it "should return 200 with valid parameters" do
      put :update, {token: @user_token, id: @subscription.id, name: "subscription_new_name", rule: "subscription_new_rule", fansub_id: 666}
      expect(response.status).to be 200
      data = JSON.parse(response.body)
      expect(data["message"]).to eq "ok"
      @subscription.reload
      expect(@subscription.name).to eq "subscription_new_name"
      expect(@subscription.rule).to eq "subscription_new_rule"
      expect(@subscription.fansub_id).to eq 666
    end

    it "should return 404 with invalid subscription id" do
      put :update, {token: @user_token, id: Subscription.last.id * 3, name: "subscription_new_name"}
      expect(response.status).to be 404
    end
  end
end
