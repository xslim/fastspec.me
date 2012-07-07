class ProjectFeature < Feature

  embedded_in :project

  def self.new_from_feature(feature)
    attributes = feature.attributes
    attributes.delete('package_ids')
    attributes.delete('image')
    attributes['original_id'] = attributes.delete('_id').to_s
    new(attributes)
  end
end