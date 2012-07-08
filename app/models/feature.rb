class Feature
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :description, :type => String
  field :estimate, :type => Integer, :default => 0
  field :image, :type => String

  has_and_belongs_to_many :packages
  belongs_to :team

  mount_uploader :image, ImageUploader
  
  embeds_many :comments

  include TeamHelper
  scope :in_team, where(team_id: TeamHelper.current_team.id)
  default_scope where(team_id: TeamHelper.current_team.id)

end

