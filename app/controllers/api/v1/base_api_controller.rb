class Api::V1::BaseApiController < ActionController::Base
  def current_user
    return @current_user if @current_user
    if @current_user.nil?
      if restrict_access_by_params || restrict_access_by_header
        @current_user = @api_key.user
      end
    end
    @current_user
  end

  protected
    def restrict_access
      if !current_user
        render status: 401, json: {error: "Access Denied."} and return
      end
      if @api_key.expired?
        @current_user.refresh_access_token!
        Rails.logger.tagged("Access Token") {Rails.logger.info "ApiKey \##{@api_key.id} expires. Token #{@api_key.access_token} is discarded."}
        render status: 401, json: {error: "Access token has expired."} and return
      end
      @current_user
    end

  private
    def restrict_access_by_params
      return true if @api_key
      return false if params[:token].nil?
      @api_key = ApiKey.find_by(access_token: params[:token])
    end

    def restrict_access_by_header
      authenticate_with_http_token do |token, options|
        return false if token.nil?
        @api_key = ApiKey.find_by(access_token: token)
      end
    end
end
