class Team
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Roles::Object

  field :name, :type => String
  field :image, :type => String

  has_and_belongs_to_many :users

  has_many :projects
  has_many :packages
  has_many :features

  mount_uploader :image, ImageUploader

end
