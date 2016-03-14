class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :last_viewed_at
end
