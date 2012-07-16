class Feature
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Document::Taggable
  
 

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
    #self.all_tags.map{|e| e[:name] }.flatten
  end

  def tag_list
  end

end

