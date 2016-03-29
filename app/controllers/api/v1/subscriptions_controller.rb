# encoding: utf-8

class Api::V1::SubscriptionsController < Api::V1::BaseApiController
  before_action :restrict_access

	def create
		render status: 400, json: {error: "Bad request! parameter 'name' or 'rule' is missing"} and return if params[:name].nil? || params[:rule].nil?
		subscription = Subscription.new(
			name: params[:name],
			rule: params[:rule],
			fansub_id: params[:fansub_id]
		)
		if subscription.save
			render status: 201, json: subscription and return
		else
			render status: 500, json: {error: "This is an error in saveing a subscribe rule"} and return
		end
	end

	def index
		subscriptions = @current_user.subscriptions.order(created_at: :desc, id: :desc)
		if params[:limit].to_i > 0
			subscriptions = subscriptions.limit(params[:limit].to_i)
		end
		render status: 200, json: subscriptions and return
	end

	def show
		subscription = Subscription.find_by_id(params[:id])
		if subscription.nil?
			render status: 404, json: {error: "Subscription not found!"} and return
		else
			render status: 200, json: subscription and return
		end
	end

	def update
		subscription = Subscription.find_by_id(params[:id])
		if subscription.nil?
			render status: 404, json: {error: "Subscription not found!"} and return
		else
			subscription.update(params.permit(:name, :rule, :fansub_id))
			render status: 200, json: {message: 'ok'}
		end
	end
end
