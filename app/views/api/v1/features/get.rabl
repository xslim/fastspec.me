collection @features

attributes :id, :name, :description, :estimate

child :team => :team do
  attributes :id, :name, :comments
end

