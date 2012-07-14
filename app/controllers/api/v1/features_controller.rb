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
    
    #
    project_feature = ProjectFeature.new_from_feature(@feature) 
    #project_feature = @project.project_features.new
    #attributes = @feature.attributes
    #attributes.delete('package_ids')
    #attributes.delete('image')
    #attributes['original_id'] = attributes.delete('_id').to_s  
    #attributes['_type'] = 'ProjectFeature'
    #project_feature.attributes = attributes

    #project_feature = ProjectFeature.new()

    @project.project_features << project_feature
      
    project_feature.image.store! feature_image.file if feature_image
    project_feature.save!
    
    if !@project.save
      @resp = {:json => {:error => 'Cannot save project'}, :status => :bad_request}
      respond_to do |format|
        format.json {render @resp}
      end
    else
      @project.reload()
      #@resp = {:json => @project.project_features.find(project_feature.id), :status => :ok} 
      @feature = @project.project_features.find(project_feature.id)
    end  
    
     
    
    #@feature = project_feature
    
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
  
  def remove_feature_from_project
    pid = params[:pid]
    fid = params[:fid]
    
    begin
      @project = Project.find(pid)
      @feature = @project.project_features.find(fid)
      if @feature.delete
        @resp = {:json => {:status => 200}, :status => :ok}
      else
        @resp = {:json => {:error => 'Cannot remove this feature'}, :status => :bad_request}  
      end  
      
    rescue Mongoid::Errors::DocumentNotFound
      @resp = {:json => {:error => 'Feature is not found in the project'}, :status => :bad_request}  
    end  
    
    respond_to do |format|
      format.json {render @resp}
    end
    
  end
  
  def attach_picture_to_feature
    pid = params[:pid]
    fid = params[:fid]
    
    
    if remotipart_submitted?
      @image = params[:image]
      
      @project = Project.find(pid)
      @feature = @project.project_features.find(fid)
      begin 
        @feature.image.store! @image
        @feature.save!
        @project.save!
      
      rescue Mongoid::Errors::InvalidCollection
        logger.error "This is workaround for carrierwave on embedded docs"
      end
      
      logger.debug "We've got a file"
      
    end
    puts @feature.image.small_thumb.inspect
    
    respond_to do |format|
      format.js
    end
    
  end  
  
end  