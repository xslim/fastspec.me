class ProjectFeature < Feature
  
  field :image, :type => String # Duplicate declaraton?
  field :original_id, :type => String
  
  embedded_in :project, :inverse_of => :project_features
  
  # note: tracking will not work until #track_history is invoked
  #include Mongoid::History::Trackable
  
  # telling Mongoid::History how you want to track changes
  # track_history   :on => [:name, :description, :estimate, :image],       # track title and body fields only, default is :all
  #             #:modifier_field => :modifier, # adds "referenced_in :modifier" to track who made the change, default is :modifier
  #             #:version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
  #             :track_create   =>  true,    # track document creation, default is false
  #             #:track_update   =>  true,     # track document updates, default is true
  #             :track_destroy  =>  true,    # track document destruction, default is false
  #             :scope => :project


  mount_uploader :image, ImageUploader            

  def self.new_from_feature(feature)
    attributes = feature.attributes
    attributes.delete('package_ids')
    attributes.delete('image')
    attributes['original_id'] = attributes.delete('_id').to_s
    new(attributes)
  end
  
  def attributes_from_feature(feature)
    #feature_image = feature.image
    
    attributes = feature.attributes
    attributes.delete('package_ids')
    attributes.delete('image')
    attributes['original_id'] = attributes.delete('_id').to_s
    #self.attributes = attributes

    return attributes

    # Only for existing ones
    #self.image.store! feature_image.file if feature_image
    #self.save!

  end
    
end