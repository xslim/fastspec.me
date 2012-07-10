class Api::V1::FeaturesController < ::Api::ApiController
  
  def get

    @features = current_team.features
      
  end
  
  def add
    
  end
  
  def add_feature_to_project
    projectId = params[:pid]
    featureId = params[:fid]
    
    @project = Project.find(projectId)
    @feature = Feature.find(featureId)
    
    feature_image = @feature.image
    
    #ProjectFeature.new_from_feature(@feature)
    
    project_feature =  @project.project_features.new
    attributes = @feature.attributes
    attributes.delete('package_ids')
    attributes.delete('image')
    attributes['original_id'] = attributes.delete('_id').to_s  
    project_feature.attributes = attributes
      
    project_feature.image.store! feature_image.file if feature_image
    #project_feature.save!

    if !@project.save
      @resp = {:json => {:error => 'Cannot save project'}, :status => :bad_request}
    else
      @resp = {:json => project_feature, :status => :ok} 
    end  
    
    respond_to do |format|
      format.json {render @resp}
    end  
    
    
  end 
  
  def add_comment_to_feature
    pid = params[:pid]
    fid = params[:fid]
    comment = params[:comment]
    
    @project = Project.find(pid)
    @feature = @project.project_features.find(fid)
    
    puts @feature.inspect
    
    #com = Comment.new
    #com.comment = comment
    #com.user_name = current_user.name
    #com.user_email = current_user.email
    #com.user_id = current_user.id
    
    @comment = @feature.comments.create({:comment => comment, :user_name => current_user.name, :user_email => current_user.email,
      :user_id => current_user.id})
    #@feature.save
    
    
    
  end 
  
end  