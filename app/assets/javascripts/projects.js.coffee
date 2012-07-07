class ProjectManager 
  
  #
  # 
  #
  constructor: (@params) ->
    @baseUrl = "http://0.0.0.0:3000/api/v1"
    
    @getFeaturesUrl = "#{@baseUrl}/features"
    
    @addProjectBtn = $('#add_project_btn')
    @addFeatureBtn = $('#add_feature_btn')
    @addFeaturePopup = $('#add_feature_popup')
    
    @addProjectBtn.on "click", @onAddProject
    @addFeatureBtn.on "click", @onAddFeature
  #
  #
  #  
  start: ->
    console.log "Start ProjectManager"
    $(".collapse").collapse()
    
      
  
  onAddProject: (e) =>
    console.log "On Add Project"
    
  onAddFeature: (e) =>
    console.log "On Add Feature"
    
    @addFeaturePopup.modal({})
    @addFeaturePopup.on 'shown', @onFeaturePopupShown
      
  onFeaturePopupShown: (e) =>
    # Fetch features
    
    if @features is `undefined` or @features is false
      
      @fetchFeatures ((features) =>
        @render(features, $('#features_list'))
      ), (error) =>
        console.log "Error loading features:", error
        
      
      
    #else
    #  @render @features
    
  render: (data, dest) =>
    console.log el, dest
    
  fetchFeatures: (successClb, errorClb) =>
    
    $.ajax
      url: @getFeaturesUrl
      dataType: 'json'
      success: (data) =>
        console.log data
        successClb(data)
        
      error: (error) =>
        console.log error
        errorClb(error)
    
jQuery ->
  $('.best_in_place').best_in_place()
  pm = new ProjectManager
  pm.start()
  