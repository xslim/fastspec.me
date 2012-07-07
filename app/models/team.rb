class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  has_and_belongs_to_many :users

  has_many :projects
  has_many :packages
  has_many :features

end
