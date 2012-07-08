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
        console.log "Got Features"
        @render(features, $('#features_list'))
        $('#accordion2').collapse({
          toggle: true
        })
        
        $('#accordion2').css 'height', '100%'
        
        @features = features
        
      ), (error) =>
        console.log "Error loading features:", error
      
        

      
    #else
    #  @render @features
    
  render: (data, dest) =>
    console.log data, dest
    
    accord = $('<div />').addClass('accordion')
    accord.attr 'id', 'accordion2'
    
    $.template "cellTmpl", "<div class='accordion-group'>" +
      "<div class='accordion-heading'>" + 
      "<a href='#${bodyId}' data-toggle='collapse' class='accordion-toggle' data-parent='#accordion2' >${name}</a></div>" +
      "<div class='accordion-body collapse' id='${bodyId}' style='height: 0px; '>"+
      "<div class='accordion-inner'>${bodyData}</div>"+
      "</div></div>" 
    
    data.map (feature) =>
      
      tmplData = 
        groupId: "group#{feature.id}"
        bodyId: "info#{feature.id}"
        bodyData: feature.description
        name: feature.name

      $.tmpl('cellTmpl', tmplData).appendTo(accord)
      
    
    dest.children().remove()  
    dest.append accord
    
    
    
    console.log data, dest
    #$(".collapse").collapse()
    
  fetchFeatures: (successClb, errorClb) =>
    
    $.ajax
      url: @getFeaturesUrl
      dataType: 'json'
      success: (data) =>
        console.log "Success", data
        successClb(data)
        
        
      error: (error) =>
        console.log error
        errorClb(error)
    
jQuery ->
  $('.best_in_place').best_in_place()
  pm = new ProjectManager
  pm.start()
  