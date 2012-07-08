class Api::V1::FeaturesController < ::Api::ApiController
  
  def get
    
    @features = Feature.all()
    puts @features
  end
  
  def add
    
    
    
  end
  
  def add_feature_to_project
    projectId = params[:pid]
    featureId = params[:fid]
    
    @project = Project.find(projectId)
    @feature = Feature.find(featureId)
    
    feature_image = @feature.image
    
    project_feature = ProjectFeature.new_from_feature(@feature)
    
    @project.project_features << project_feature
      
    project_feature.image.store! feature_image.file if feature_image
    project_feature.save!

    if !@project.save
      @resp = {:json => {:error => 'Cannot save project'}, :status => :bad_request}
    else
      @resp = {:json => project_feature, :status => :ok} 
    end  
    
    respond_to do |format|
      format.json {render @resp}
    end  
    
    
  end  
  
end  