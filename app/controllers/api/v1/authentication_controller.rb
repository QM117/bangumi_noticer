class Api::V1::AuthenticationController < Api::V1::BaseApiController

  def token
    if params[:email].nil? || params[:password].nil?
      render status: 400, json: {error: "Please provide your email and password to verify your identity"} and return
    end
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      token = user.api_key.access_token
      render status: 200, json: token and return
    else
      render status: 401, json: {error: "Unauthorized to access"} and return
    end
  end
end
