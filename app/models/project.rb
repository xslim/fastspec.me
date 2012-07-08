class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String

  belongs_to :team

  embeds_many :project_features#, cascade_callbacks: true

  include TeamHelper
  scope :in_team, where(team_id: TeamHelper.current_team_id)
  default_scope where(team_id: TeamHelper.current_team_id)

end
