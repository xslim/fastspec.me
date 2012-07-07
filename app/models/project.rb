class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  embeds_many :project_features, cascade_callbacks: true

end
