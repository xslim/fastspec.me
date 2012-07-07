class ProjectManager 
  
  #
  # 
  #
  constructor: (@params) ->
    @addProjectBtn = $('#add_project_btn')
    
    @addProjectBtn.on "click", @onAddProject
  #
  #
  #  
  start: ->
    console.log "Start ProjectManager"
      
  
  onAddProject: (e) =>
    
    console.log "On Add Project"
    
    
jQuery ->
  $('.best_in_place').best_in_place()
  pm = new ProjectManager
  pm.start()
  