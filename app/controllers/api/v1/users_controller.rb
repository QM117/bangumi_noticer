# encoding: utf-8

class Api::V1::UsersController < Api::V1::BaseApiController
  before_action :restrict_access, except: [:create]

  def show
    render status: 400, json: {error: "Bad request! Some parameters is missing or invalid."} and return if params[:id].nil?
    user = User.find_by_id(params[:id].to_i)
    render status: 404, json: {error: "User not found by this id."} and return if user.nil?
    render status: 401, json: {error: "You are not authorized to access the resource"} and return if @current_user.id != params[:id].to_i
    render status: 200, json: user and return
  end

  def create
    if params[:email].nil? || params[:name].nil? || params[:password].nil?
      render status: 400, json: {error: "Bad request! Some parameters is missing or invalid."} and return
    end

    user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      last_viewed_at: DateTime.now
    )

    if user.save
      render status: 201, json: user and return
    else
      render status: 500, json: {error: "There is an error in saving a user"} and return
    end
  end

  def subscribe
    if params[:subscription_id].nil?
      render status: 400, json: {error: "Bad request! Some parameters is missing or invalid"} and return
    end
    subscription = Subscription.find_by_id(params[:subscription_id])
    @current_user.subscriptions.append(subscription)
    render status: 200, json: {message: 'ok'}
  end

  def unsubscribe
    if params[:subscription_id].nil?
      render status: 400, json: {error: "Bad request! Some parameters is missing or invalid"} and return
    end
    subscription = Subscription.find_by_id(params[:subscription_id])
    @current_user.subscriptions.delete(subscription)
    render status: 200, json: {message: 'ok'}
  end
end
