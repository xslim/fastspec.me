class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Roles::Object
  
  field :name, :type => String
  field :share_token, :type => String

  belongs_to :team

  embeds_many :project_features, :inverse_of => :project, cascade_callbacks: true
  #accepts_nested_attributes_for :project_features

  include TeamHelper
  #scope :in_team, { where(team_id: TeamHelper.current_team_id) }
  scope :in_team, ->(t) { where(team_id: t.id) }
  #default_scope where(team_id: TeamHelper.current_team_id)
  

  def self.find_by_share_token(token)
    self.find_by(share_token: token)
  end

  def total_estimate
    self.project_features.sum(:estimate)
  end
  

end
