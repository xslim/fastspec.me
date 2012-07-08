class ProjectManager 
  
  #
  # 
  #
  constructor: (@params) ->
    @baseUrl = "http://0.0.0.0:3000/api/v1"
    
    @getFeaturesUrl = "#{@baseUrl}/features"
    @addFeatureToProjectUri = "#{@baseUrl}/project/feature.json"
    
    @addProjectBtn = $('#add_project_btn')
    @addFeatureBtn = $('#add_feature_btn')
    @addFeaturePopup = $('#add_feature_popup')
    
    @addProjectBtn.on "click", @onAddProject
    @addFeatureBtn.on "click", @onAddFeature
    
    $(document.body).on 'FS::AddFeatureToProject', @onAddFeatureToProject
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
      "<a href='javascript:void(0)' data-feature-id='${fid}' class='addFeature btn btn-success'  style='position:absolute; right: 10px; margin-top:4px;'><i class='icon-plus'></i></a>" +
      "<a href='#${bodyId}' data-toggle='collapse' class='accordion-toggle' data-parent='#accordion2' >${name}</a></div>"+

      "<div class='accordion-body collapse' id='${bodyId}' style='height: 0px; '>"+
      "<div class='accordion-inner'>${bodyData}</div>"+
      "</div></div>" 
    
    data.map (feature) =>
      
      tmplData = 
        fid: feature.id
        groupId: "group#{feature.id}"
        bodyId: "info#{feature.id}"
        bodyData: feature.description
        name: feature.name

      $.tmpl('cellTmpl', tmplData).appendTo(accord)
      
    
    dest.children().remove()  
    dest.append accord
    
    
    
    console.log data, dest
    $('.addFeature').on 'click', @onDoAddFeature
    #$(".collapse").collapse()
  
  
  onDoAddFeature: (e) =>
    fid = $(e.currentTarget).attr 'data-feature-id'
    console.log "Adding #{fid} to the project"
    
    @addFeaturePopup.modal 'hide'
    pid = @addFeaturePopup.attr 'data-project-id'
    $(document.body).trigger('FS::AddFeatureToProject', [fid, pid]);
    
    
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
  
  onAddFeatureToProject: (e, fid, projectId) =>
    console.log "Fired FS::AddFeatureToProject, adding #{fid} to project #{projectId}"
    @projectId = projectId
    $.ajax
      url: @addFeatureToProjectUri
      type: 'post'
      dataType: 'json'
      data:
        pid: projectId
        fid: fid
      success: (data) =>
        console.log 'Added feature', data
        @addFeatureRow(data)
            
      error: (error) =>
        console.log error
    
  
  addFeatureRow: (feature) =>
    feature.project_id = @projectId
    $.template "featureRow",  "<tr><td>" +
      '<span class="best_in_place" id="best_in_place_feature_${id}_name" data-url="/projects/${project_id}/update/feature/${id}" data-object="feature" data-attribute="name" data-nil="Something" data-type="input">${name}</span>' +
      '</td>' +
      '<td><span class="best_in_place" id="best_in_place_feature_${id}_estimate" data-url="/projects/${project_id}/update/feature/${id}" data-object="feature" data-attribute="estimate" data-nil="0" data-type="input">${estimate}</span></td>' +
      '<td><a href="/projects/${project_id}/delete/feature/${id}" data-method="delete" rel="nofollow">Delete</a></td></tr>'

    
    renderedFeature = $.tmpl('featureRow', feature)
    
    $('#featureListTable tr:last').after(renderedFeature)
    
jQuery ->
  $('.best_in_place').best_in_place()
  pm = new ProjectManager
  pm.start()
  