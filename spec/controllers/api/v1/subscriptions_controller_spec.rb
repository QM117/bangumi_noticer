require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "create function" do
    it "should create a subscription and return data with valid parameters" do
      post :create, {name: "subscription name", rule: "subscription_rule"}
      expect(response.status).to be 201
      data = JSON.parse(response.body)
      subscription = Subscription.find_by_id(data["subscription"]["id"])

      expect(subscription).not_to be_nil
      expect(subscription.name).to eq("subscription name")
      expect(subscription.rule).to eq("subscription_rule")
    end

    it "should return 400 without valid parameters" do
      post :create, {name: "subscription name"}
      expect(response.status).to be 400
    end
  end

  describe "show function" do
    before do
      @subscription = FactoryGirl.create(:subscription)
    end

    it "should return 200 with valid parameters" do
      get :show, {id: @subscription.id}
      expect(response.status).to be 200
      data = JSON.parse(response.body)
      expect(data["subscription"]["id"]).to eq @subscription.id
      expect(data["subscription"]["name"]).to eq @subscription.name
      expect(data["subscription"]["rule"]).to eq @subscription.rule
    end

    it "should not get anything without id" do
      expect {
        get :show, {}
      }.to raise_error(ActionController::UrlGenerationError)
    end

    it "should return 404 with invalid id" do
      get :show, {id: Subscription.last.id * 3}
      expect(response.status).to be 404
    end
  end
end
