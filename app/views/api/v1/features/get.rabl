collection @features

attributes :id, :name, :description, :estimate, :image

child :team => :team do
  attributes :id, :name, :comments
end

