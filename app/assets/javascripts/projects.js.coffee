class ProjectManager 
  
  #
  # 
  #
  constructor: (@params) ->
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
    
      
    
    
jQuery ->
  $('.best_in_place').best_in_place()
  pm = new ProjectManager
  pm.start()
  