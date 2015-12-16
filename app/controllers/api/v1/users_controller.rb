# encoding: utf-8

class Api::V1::UsersController < Api::V1::BaseApiController
  before_action :restrict_access, except: [:create]

	def show
		render status: 400, json: {error: "Bad request! Some parameters is missing or invalid."} and return if params[:id].blank?
		user = User.find_by_id(params[:id].to_i)
		render status: 404, json: {error: "User not found by this id."} and return if user.nil?
		render status: 200, json: user and return
	end

  def create
    render status: 400, json: {error: "Bad request! Some parameters is missing or invalid."} and return if params[:email].nil? || params[:name].nil?

    user = User.new(
      name: params[:name],
      email: params[:email]
    )

    if user.save
      render status: 201, json: user and return
    else
      render status: 500, json: {error: "There is an error in saving a user"} and return
    end
  end
end
