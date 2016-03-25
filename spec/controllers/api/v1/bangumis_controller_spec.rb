require 'rails_helper'

RSpec.describe Api::V1::BangumisController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @user_token = @user.api_key.access_token
  end

  describe "get unread bangumis" do
    before do
      @subscription_1 = FactoryGirl.create(:subscription)
      @subscription_2 = FactoryGirl.create(:subscription)
      @subscription_3 = FactoryGirl.create(:subscription)

      @user.subscriptions << @subscription_1 << @subscription_2 << @subscription_3

      @bangumi_1 = FactoryGirl.create(:bangumi)
      @bangumi_2 = FactoryGirl.create(:bangumi)
      @bangumi_3 = FactoryGirl.create(:bangumi)
      @bangumi_4 = FactoryGirl.create(:bangumi)
      @bangumi_5 = FactoryGirl.create(:bangumi)
      @bangumi_6 = FactoryGirl.create(:bangumi)

      @bangumi_4.update(created_at: 3.days.ago)
      @bangumi_5.update(created_at: 5.days.ago)
      @bangumi_6.update(created_at: 7.days.ago)

      @subscription_1.bangumis << @bangumi_1 << @bangumi_3
      @subscription_2.bangumis << @bangumi_1 << @bangumi_2
      @subscription_3.bangumis << @bangumi_4 << @bangumi_5 << @bangumi_6
    end

    it "should return 401 without correct token" do
      get :unread, {token: "829ba335e4ce46b74397f4803cc90757"}
      expect(response.status).to be 401
    end

    it "should return 400 with invalid from_date or to_date" do
      get :unread, {token: @user_token, from_date: "AAAAAAAA"}
      expect(response.status).to be 400
    end

    # correct cases
    it "should return bangumi 1, 2, 3, 4, 5 with valid parameters" do
      get :unread, {token: @user_token}
      expect(response.status).to be 200
      bangumis = JSON.parse(response.body)["bangumis"]
      expect(bangumis.length).to be 5

      expect(bangumis[0]["id"]).to eq @bangumi_5.id
      expect(bangumis[0]["title"]).to eq @bangumi_5.title
      expect(DateTime.parse(bangumis[0]["upload_at"]).to_i).to eq @bangumi_5.upload_at.to_i
      expect(bangumis[0]["fansub"]).to eq @bangumi_5.fansub
      expect(bangumis[0]["size"]).to eq @bangumi_5.size
      expect(bangumis[0]["magnet_link"]).to eq @bangumi_5.magnet_link
      expect(bangumis[0]["viewed"]).to eq true

      expect(bangumis[1]["id"]).to eq @bangumi_4.id
      expect(bangumis[0]["viewed"]).to eq true

      expect(bangumis[2]["id"]).to eq @bangumi_3.id
      expect(bangumis[2]["viewed"]).to eq false

      expect(bangumis[3]["id"]).to eq @bangumi_2.id
      expect(bangumis[3]["viewed"]).to eq false

      expect(bangumis[4]["id"]).to eq @bangumi_1.id
      expect(bangumis[4]["viewed"]).to eq false
    end

    it "should return bangumi 3, 4, 5 with limit 3" do
      get :unread, {token: @user_token, limit: 3}
      expect(response.status).to be 200
      bangumis = JSON.parse(response.body)["bangumis"]
      expect(bangumis.length).to be 3
      expect(bangumis[0]["id"]).to eq @bangumi_5.id
      expect(bangumis[1]["id"]).to eq @bangumi_4.id
      expect(bangumis[2]["id"]).to eq @bangumi_3.id
    end

    it "should return bangumi 4, 5 within period" do
      get :unread, {token: @user_token, from_date: 6.day.ago, to_date: 1.day.ago}
      expect(response.status).to be 200
      bangumis = JSON.parse(response.body)["bangumis"]
      expect(bangumis.length).to be 2
      expect(bangumis[0]["id"]).to eq @bangumi_5.id
      expect(bangumis[1]["id"]).to eq @bangumi_4.id
    end
  end
end