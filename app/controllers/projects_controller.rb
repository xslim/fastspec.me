class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :except => [:shared]
  respond_to :html, :json, :pdf
  layout "preview", :only => [:shared]
  
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.in_team(current_team).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    #puts "--> #{Project.in_team.inspect}"
    @project = Project.in_team(current_team).find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
      format.pdf
    end
  end

  def share
    @project = Project.in_team(current_team).find(params[:id])
    @project.share_token ||= Devise.friendly_token[0,7]
    @project.save

    render :show
  end

  def unshare
    @project = Project.in_team(current_team).find(params[:id])
    @project.share_token = nil
    @project.save

    render :show
  end

  def shared
    @project = Project.in_team(current_team).find_by_share_token(params[:token])
    @team = (@project.team rescue nil)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
      format.pdf
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.in_team(current_team).find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])
    @project.team = current_team

    current_user.has_role!(:write, @project)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.in_team(current_team).find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { respond_with_bip @project }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.in_team(current_team).find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end


  def add_feature
    @project = Project.in_team(current_team).find(params[:id])

    feature = (Feature.find(params[:feature_id]) rescue nil)

    if feature.nil?
      redirect_to @project, alert: 'Feature was not found.' and return
    end

    feature_image = feature.image

    #@project.project_features = nil

    project_feature = ProjectFeature.new_from_feature(feature)

    if @project.project_features << project_feature

      project_feature.image.store! feature_image.file if feature_image
      project_feature.save!

      @project.save

      redirect_to @project, notice: 'Feature was was added.'
    else
      redirect_to @project, alert: 'Problem adding Feature.'
    end
  end

  def delete_feature
    @project = Project.in_team(current_team).find(params[:id])
    feature = (@project.project_features.find(params[:feature_id]) rescue nil)

    if feature.nil?
      redirect_to @project, alert: 'Feature was not found.' and return
    end
    
    puts feature.inspect
    puts @project.project_features.inspect
    
    if @project.project_features.where(:_id => feature.id.to_s).delete_all
      #@project.reload
      redirect_to @project, notice: 'Feature was deleted.'
    else
      redirect_to @project, alert: 'Problem removing Feature.'
    end
    
  end

  def update_feature
    @project = Project.in_team(current_team).find(params[:id])
    feature = (@project.project_features.find(params[:feature_id]) rescue nil)

    if feature
      feature.attributes = params[:project_feature]
      if @project.save
        respond_with_bip @project.project_features.find(params[:feature_id])
      else 
        logger.error "Cannot save project"  
      end    
    end
  end

  def update_features
    @project = Project.in_team(current_team).find(params[:id])

    @project.project_features.each do |f|
      original_feature = (Feature.find(f.original_id) rescue nil)
      if original_feature
        attributes = f.attributes_from_feature(original_feature)
        puts "---> attributes: #{attributes.inspect}"
        f.attributes = attributes
        @project.save
      end
    end

    redirect_to @project, alert: 'Features were updated!' and return
  end

end
