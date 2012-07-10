class ProjectManager 
  
  #
  # 
  #
  constructor: (@params) ->
    @baseUrl = "http://#{location.host}/api/v1"
    
    @getFeaturesUrl = "#{@baseUrl}/features"
    @addFeatureToProjectUri = "#{@baseUrl}/project/feature.json"
    @addCommentToFeatureInProjectUrl = "#{@baseUrl}/project/feature/comment.json"
    @deleteFeatureFromProjectUrl = "#{@baseUrl}/project/feature.json" # DELETE
    
    @addProjectBtn = $('#add_project_btn')
    @addFeatureBtn = $('#add_feature_btn')
    @addFeaturePopup = $('#add_feature_popup')
    @addCommentBtn = $('.add_comment_btn')
    @saveCommentBtn = $('#save_comment_btn')
    @addCommentForm = $('#add_comment_form')
    @removeFeatureBtn = $('.remove_feature_btn')
    
    @addProjectBtn.on "click", @onAddProject
    @addFeatureBtn.on "click", @onAddFeature
    @addCommentBtn.on "click", @onAddComment
    @saveCommentBtn.on "click", @onCommentSave
    @removeFeatureBtn.bind "click", @onRemoveFeature
    
    $(document.body).bind 'FS::FeatureListUpdated', @onListUpdated
    
    $(document.body).bind 'FS::AddFeatureToProject', @onAddFeatureToProject
    
    @bindBestInPlace()
  
  
  bindBestInPlace: =>
    $(".best_in_place").off "ajax:success"
    $(".best_in_place").bind "ajax:success", () =>
       console.log "Success on in-place update"
       $(document.body).trigger 'FS::FeatureListUpdated'  
  #
  #
  #  
  start: ->
    console.log "Start ProjectManager"
    
    
  
  onListUpdated: =>
    console.log "On List Updated"
    @updateEstimateTotal()    
  
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
        @updateEstimateTotal()
        
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
    $.template "featureRow",  "<tr data-target='#details_${_id}' data-toggle='collapse' data-row-feature-id='${_id}'><td>" +
      '<span class="best_in_place" id="best_in_place_project_feature_${_id}_name" ' +
        'data-url="/projects/${project_id}/update/feature/${_id}" data-object="project_feature" data-attribute="name" '+
        'data-nil="Enter feature name" data-type="input">${name}</span>' +
      '</td>' +
      '<td><span class="best_in_place" id="best_in_place_project_feature_${_id}_estimate" ' +
        'data-url="/projects/${project_id}/update/feature/${_id}" data-object="project_feature" '+
        'data-attribute="estimate" data-nil="0" data-type="input">${estimate}</span></td>' +
      '<td><button class="btn btn-mini btn-danger remove_feature_btn" data-feature-id="${_id}">Remove</button></td>'+
      '</tr>' +
      '<tr data-row-feature-id="${_id}"><td colspan="3" style="height: 0px; padding:0; margin: 0; border-top: 0;">' +
      '<div class="collapse in" id="details_${_id}" style="height: auto; ">' +
      '<div class="alert alert-info">' +
      '<span class="best_in_place" id="best_in_place_project_feature_${_id}_description" '+
        'data-url="/projects/${project_id}/update/feature/${_id}" data-object="project_feature" '+
        'data-attribute="description" data-nil="Enter Description of this Task" data-type="input">${description}</span></div>' +
      '<br><div class="comments" id="comments_${_id}"></div>' +
      '<div class="btn-group">' +
      '<button class="add_comment_btn btn btn-success btn-mini" data-feature-id="${_id}">Add comment</button>' +
      '</div></div></td></tr>' 

    renderedFeature = $.tmpl('featureRow', feature)
    
    $('#featureListTable tr:last').before(renderedFeature)
    
    commentBtn = $('.add_comment_btn')
    commentBtn.off 'click'
    commentBtn.on "click", @onAddComment
    $(document.body).trigger 'FS::FeatureListUpdated'
    removeBtn = $('.remove_feature_btn')
    removeBtn.off 'click'
    removeBtn.bind 'click', @onRemoveFeature
    @bindBestInPlace()
    
  updateEstimateTotal: =>
    
    elements = $('span[data-attribute="estimate"]')
    value = 0
    elements.map (index, element) =>
      value = value + parseInt(element.innerHTML)
    console.log "Update estimate to #{value} hours"
    $('#estimate_total').text(value)
    
  onAddComment: (e) =>
    btn = $(e.currentTarget)
    fid = btn.attr 'data-feature-id'
    console.log "Add a comment to feature #{fid}"
    cWrapper = $("#comments_#{fid}")

    form = $('#add_comment_form')
    form.modal({})
    field = $('#comment_fld')
    field.attr 'data-feature-id', fid
    field.val('')
    field.focus()
    
    console.log field
  
  onCommentSave: (e) =>
    form = $('#add_comment_form')
    form.modal('hide')      
    
    pid = form.attr "data-project-id"
          
    field = $('#comment_fld')  
    fid = field.attr 'data-feature-id'  
    console.log "Comment #{field.val()}"
    console.log "Fid: #{fid}"
    console.log "ProjectId: #{pid}"
    
    cWrapper = $("#comments_#{fid}")
    
    $.ajax
      url: @addCommentToFeatureInProjectUrl
      type: 'post'
      dataType: 'json'
      data:
        pid: pid
        fid: fid
        comment: field.val()
      success: (data) =>
        console.log data
        $.template "commentRow", '<div class="alert alert-info">${comment}<br>by ${user_name} at ${created_at}</div>'
        
        $.tmpl('commentRow', data).appendTo(cWrapper)
        
      error: (error) =>
        console.log error 
  
  onRemoveFeature: (e) =>
    btn = $(e.currentTarget)
    fid = btn.attr 'data-feature-id'
    form = $('#add_comment_form')
    pid = form.attr "data-project-id"
    
    $.ajax
      url: @deleteFeatureFromProjectUrl       
      type: 'delete'
      dataType: 'json'
      data:
        pid: pid
        fid: fid
      success: (data) =>
        if data.status is 200
          rows = $("tr[data-row-feature-id=#{fid}]")
          rows.remove()
          $(document.body).trigger 'FS::FeatureListUpdated'
        
      error: (xhr, error, text) =>
        console.log xhr.responseText    
        resp = JSON.parse(xhr.responseText)
        
        if resp isnt null and resp.error isnt null
          alert resp.error
  
      
    console.log "Remove feature #{fid} from project #{pid}"
    #
      
jQuery ->
  $('.best_in_place').best_in_place()
  pm = new ProjectManager
  pm.start()
  window.pm = pm
  