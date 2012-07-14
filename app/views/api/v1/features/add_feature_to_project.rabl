object @feature

attributes :id, :name, :created_at, :description, :comments, :estimate

node :image do |f|
  {:thumb => f.image.thumb.url,
   :url => f.image.url,
   :small_thumb => f.image.small_thumb.url}
end  