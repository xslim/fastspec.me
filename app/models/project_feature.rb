class ProjectFeature < Feature
  
  field :original_id, :type => String
  field :project_id, :type => String # If of the parent project
  embedded_in :project, :inverse_of => :project_features
  
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