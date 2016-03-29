class Api::V1::BangumisController < Api::V1::BaseApiController
  before_action :restrict_access

  def unread
    if !params[:from_date].blank? || !params[:to_date].blank?
      begin
        from_date = params[:from_date].blank? ? 7.days.ago : DateTime.parse(params[:from_date])
        to_date = params[:to_date].blank? ? DateTime.now : DateTime.parse(params[:to_date])
      rescue
        render status: 400, json: {error: "Bad request! The parameter 'from_date' or 'to_date' is invalid."} and return
      end
    else
      from_date = 7.days.ago
      to_date = DateTime.now
    end

    limit = params[:limit].to_i || 20
    # filtering by created date and subscription
    bangumis = Bangumi.where(created_at: from_date..to_date).joins(:subscriptions)
              .where(subscriptions: {id: @current_user.subscriptions.map{|subscription| subscription.id}})
              .order(upload_at: :desc, id: :desc).uniq

    if limit > 0
      bangumis = bangumis.limit(limit)
    end

    render json: bangumis, last_viewed_at: @current_user.last_viewed_at

    @current_user.update(last_viewed_at: DateTime.now)
  end
end