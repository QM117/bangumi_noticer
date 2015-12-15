class Api::V1::BaseApiController < ActionController::Base
  def current_user
    return @current_user if @current_user
    if @current_user.nil?
      restrict_access_by_params
    end
    @current_user
  end

  private
    def restrict_access_by_params
      renturn false if params[:name].nil? || params[:email].nil?
      @current_user = User.find_by(name: params[:name], email: params[:email])
    end
end