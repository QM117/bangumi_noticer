# encoding: utf-8
require 'open-uri'

class Api::V1::NoticerController < Api::V1::BaseApiController
  before_action :restrict_access

  def index
    if params[:name].nil? || params[:email].nil?
      render status: 400, json: {error: "Bad request! The params 'name' or 'email' is missing."} and return
    end

    result = Bangumi.where(created_at: @current_user.last_viewed_at..DateTime.now).joins(subscription).where(subscriptions: {id: @current_user.subscriptions.map{|subscription| subscription.id}})

    @current_user.last_viewed_at = DateTime.now
    @current_user.save

    render status: 200, json: result and return

  end
end
