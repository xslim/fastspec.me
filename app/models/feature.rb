class Feature
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::Taggable
  
  # note: tracking will not work until #track_history is invoked
  include Mongoid::History::Trackable
  
  # telling Mongoid::History how you want to track changes
  track_history   :on => [:name, :description, :estimate, :image],       # track title and body fields only, default is :all
              :modifier_field => :modifier, # adds "referenced_in :modifier" to track who made the change, default is :modifier
              :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
              :track_create   =>  true,    # track document creation, default is false
              :track_update   =>  true,     # track document updates, default is true
              :track_destroy  =>  true    # track document destruction, default is false

  field :name, :type => String
  field :description, :type => String
  field :estimate, :type => Integer, :default => 0
  field :image, :type => String

  has_and_belongs_to_many :packages
  belongs_to :team

  mount_uploader :image, ImageUploader
  
  embeds_many :comments, cascade_callbacks: true

  def comments_count
    self.comments.count
  end

  include TeamHelper
  scope :in_team, where(team_id: TeamHelper.current_team_id)
  #default_scope where(team_id: TeamHelper.current_team_id)
  
  #attr_accessible :image, :image_cache

  def self.tags
    self.all_tags.map{|e| e[:name] }.flatten
  end

end

