# encoding: utf-8
require 'open-uri'

class Api::V1::NoticerController < Api::V1::BaseApiController
  before_action :restrict_access

  def index
    if !params[:from_date].blank? || !params[:to_date].blank?
      begin
        from_date = params[:from_date].blank? ? Time.at(0) : Time.parse(params[:from_date])
        to_date = params[:to_date].blank? ? Time.now : Time.parse(params[:from_date])
      rescue
        render status: 400, json: {error: "Bad request! The parameter 'from_date' or 'to_data' is invalid."} and return
      end
    else
      from_date = Time.now - 7.days
      to_date = Time.now
    end

    # filtering by created date and subscription
    bangumis = Bangumi.where(created_at: from_date..to_date).joins(:subscriptions).where(subscriptions: {id: @current_user.subscriptions.map{|subscription| subscription.id}})

    # filtering by the limit of the number
    if !params[:limit].blank?
      bangumis = bangumis.limit(params[:limit].to_i)
    end

    render json: bangumis, last_viewed_at: @current_user.last_viewed_at

    @current_user.last_viewed_at = DateTime.now
    @current_user.save
  end
end
