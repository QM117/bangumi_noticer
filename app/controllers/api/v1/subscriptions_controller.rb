# encoding: utf-8

class Api::V1::SubscriptionsController < Api::V1::BaseApiController
	def create
		render status: 400, json: {error: "Bad request! parameter 'name' or 'rule' is missing"} and return if params[:name].nil? || params[:rule].nil?
		subscription = Subscription.new(
			name: params[:name],
			rule: parmas[:rule]
		)
		if subscription.save
			render status: 201, json: {message: "OK"} and return
		else
			render status: 500, json: {error: "This is an error in saveing a subscribe rule"} and return
		end
	end
end