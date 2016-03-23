class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :rule, :fansub_id
end
