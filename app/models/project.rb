class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Roles::Object
  
  field :name, :type => String
  field :share_token, :type => String

  belongs_to :team

  embeds_many :project_features, :inverse_of => :project, cascade_callbacks: true
  accepts_nested_attributes_for :project_features

  include TeamHelper
  scope :in_team, where(team_id: TeamHelper.current_team_id)
  #default_scope where(team_id: TeamHelper.current_team_id)
  
  include Mongoid::History::Trackable

  def self.find_by_share_token(token)
    self.first(conditions: { share_token: token} )
  end

  def total_estimate
    self.project_features.sum(:estimate)
  end
  
  # telling Mongoid::History how you want to track changes
  track_history   :on => [:name],       # track title and body fields only, default is :all
              :modifier_field => :modifier, # adds "referenced_in :modifier" to track who made the change, default is :modifier
              :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
              :track_create   =>  true,    # track document creation, default is false
              :track_update   =>  true,     # track document updates, default is true
              :track_destroy  =>  true    # track document destruction, default is false

end
