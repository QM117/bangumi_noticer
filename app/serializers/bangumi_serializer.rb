class BangumiSerializer < ActiveModel::Serializer
  attributes :id, :title, :upload_at, :fansub, :size, :magnet_link, :viewed

  def viewed
    object.created_at < serialization_options[:last_viewed_at] # active_model_serializer 0.9.3
  end
end
