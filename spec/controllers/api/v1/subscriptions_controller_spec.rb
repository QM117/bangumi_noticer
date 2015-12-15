require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "create function" do
    it "should create a subscription and return valid data" do
      post :create, {name: "subscription name", rule: "subscription_rule"}
      expect(response.status).to be 201
      data = JSON.parse(response.body)
      p data
      subscription = Subscription.find_by_id(data["id"])

      expect(subscription).not_to be_nil
      expect(subscription.name).to eq("subscription name")
      expect(subscription.rule).to eq("subscription_rule")
    end
  end
end
