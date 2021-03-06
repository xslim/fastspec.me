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
    @addImagePopup = $('#add_image_popup')
    @addImageBtn = $('.add_image_btn')
    
    
    @addProjectBtn.on "click", @onAddProject
    @addFeatureBtn.on "click", @onAddFeature
    @addCommentBtn.on "click", @onAddComment
    @saveCommentBtn.on "click", @onCommentSave
    @removeFeatureBtn.bind "click", @onRemoveFeature
    @addImageBtn.bind "click", @onAddImage
    
    $(document.body).bind 'FS::FeatureListUpdated', @onListUpdated
    
    $(document.body).bind 'FS::FeatureListLoaded', @onListLoaded
    
    $(document.body).bind 'FS::AddFeatureToProject', @onAddFeatureToProject
    
    $(document.body).bind 'FS::EstimateUpdated', @updateEstimateTotal
    
    @bindBestInPlace()
  
  
  bindBestInPlace: =>
    $(".best_in_place").off "ajax:success"
    $(".best_in_place").bind "ajax:success", (e) =>
      
      if e.currentTarget.id.match(/estimate/)
        $(document.body).trigger "FS::EstimateUpdated", [e, true]
      console.log "Success on in-place update", e
      #$(document.body).trigger 'FS::FeatureListUpdated', [e]
  #
  #
  #  
  start: ->
    console.log "Start ProjectManager"
    
    $(document.body).trigger 'FS::FeatureListLoaded'
    
  
  onListLoaded: (e) =>
    console.log "On List Loaded"
    $(document.body).trigger "FS::EstimateUpdated", [e, false]
    
  
  onListUpdated: =>
    console.log "On List Updated"
    
  
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
        
        #@updateEstimateTotal()
        
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
    # $.template "featureRow",  "<tr data-target='#details_${_id}' data-toggle='collapse' data-row-feature-id='${_id}'><td>" +
    #       '<span class="best_in_place" id="best_in_place_project_feature_${_id}_name" ' +
    #         'data-url="/projects/${project_id}/update/feature/${_id}" data-object="project_feature" data-attribute="name" '+
    #         'data-nil="Enter feature name" data-type="input">${name}</span>' +
    #       '</td>' +
    #       '<td><span class="best_in_place" id="best_in_place_project_feature_${_id}_estimate" ' +
    #         'data-url="/projects/${project_id}/update/feature/${_id}" data-object="project_feature" '+
    #         'data-attribute="estimate" data-nil="0" data-type="input">${estimate}</span></td>' +
    #       '<td><button class="btn btn-mini btn-danger remove_feature_btn" data-feature-id="${_id}">Remove</button></td>'+
    #       '</tr>' +
    #       '<tr data-row-feature-id="${_id}"><td colspan="3" style="height: 0px; padding:0; margin: 0; border-top: 0;">' +
    #       '<div class="collapse in" id="details_${_id}" style="height: auto; ">' +
    #       '<div class="alert alert-info">' +
    #       '<span class="best_in_place" id="best_in_place_project_feature_${_id}_description" '+
    #         'data-url="/projects/${project_id}/update/feature/${_id}" data-object="project_feature" '+
    #         'data-attribute="description" data-nil="Enter Description of this Task" data-type="input">${description}</span></div>' +
    #       '<br><div class="comments" id="comments_${_id}"></div>' +
    #       '<div class="btn-group" style="margin:5px">' +
    #       '<button class="add_comment_btn btn btn-success btn-mini" data-feature-id="${_id}">Add comment</button>' +
    #       '<button class="add_image_btn btn btn-alert btn-mini" data-feature-id="${_id}">Attach image</button>'  
    #       '</div></div></td></tr>' 

    if feature.comments != `undefined` and feature.comments.length > 0
      feature.has_comment = true
    
    #feature.id = feature._id  
    #data = {f: feature}
    #console.log "Data: ", data
    renderedFeature = HoganTemplates['templates/project_feature'].render(feature) #$.tmpl('featureRow', feature)
    
    $('#featureListTable tr:last').before(renderedFeature)
    
    commentBtn = $('.add_comment_btn')
    commentBtn.off 'click'
    commentBtn.on "click", @onAddComment
    
    $(document.body).trigger 'FS::FeatureListUpdated'
    
    removeBtn = $('.remove_feature_btn')
    removeBtn.off 'click'
    removeBtn.bind 'click', @onRemoveFeature
    
    attachBtn = $('.add_image_btn')
    attachBtn.off 'click'
    attachBtn.bind 'click', @onAddImage
    
    @bindBestInPlace()
    
    $(document.body).trigger "FS::EstimateUpdated", [null, true]
    
  updateEstimateTotal: (e, origEvent, showPopup) =>
    
    elements = $('span[data-attribute="estimate"]')
    value = 0
    elements.map (index, element) =>
      value = value + parseInt(element.innerHTML)
    console.log "Update estimate to #{value} hours"
    $('#estimate_total').text(value)
    
    
    if showPopup is true
      $.gritter.add
        title: "Estimate updated"
        text: "The total estimate has been updated to #{value} hours" 
        image: "http://www.veryicon.com/icon/png/System/Mini/update.png"
        sticky: false
        time: ""
    
    
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
        #$.template "commentRow", '<div class="alert alert-info">${comment}<br>by ${user_name} at ${created_at}</div>'
        comment = HoganTemplates['templates/comment'].render(data)
        cWrapper.append(comment)
        #$.tmpl('commentRow', data).appendTo(cWrapper)
        
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
          console.log rows
          rows.remove()
          $(document.body).trigger "FS::EstimateUpdated", [e, true]
          $(document.body).trigger 'FS::FeatureListUpdated'
        
      error: (xhr, error, text) =>
        console.log xhr.responseText    
        resp = JSON.parse(xhr.responseText)
        
        if resp isnt null and resp.error isnt null
          alert resp.error
  
      
    console.log "Remove feature #{fid} from project #{pid}"
    #
  onAddImage: (e) =>
    btn = $(e.currentTarget)
    fid = btn.attr 'data-feature-id'
    
    form = $('#add_image_popup')
    pid = form.attr "data-project-id"
    
    console.log "Attaching image to feature #{fid} in project #{pid}"
    
    pid_fld = $('#attach_image_form > #pid')
    fid_fld = $('#attach_image_form > #fid')
    
    pid_fld.val(pid)
    fid_fld.val(fid)
    
    form.modal()
      
    $(document.body).bind "FS::ImageUploaded", (e, url, thumb) =>
      form.modal('hide')
      console.log "File is uploaded", filename 
      
      img = $("#img#{fid}")  
      console.log img 
      img.attr 'src', url
      imgBig = $("#img_100_#{fid}}")
      imgBig.attr 'src', thumb
      $(document.body).off 'FS::ImageUploaded'
      
      
jQuery ->
  $('.best_in_place').best_in_place()
  pm = new ProjectManager
  pm.start()
  window.pm = pm
  