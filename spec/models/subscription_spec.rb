require 'rails_helper'

describe Subscription do
  before do
    subscription = FactoryGirl.create(:subscription)
  end

  it {should respond_to(:name)}
  it {should respond_to(:rule)}
end
