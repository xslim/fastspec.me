module MustacheTemplateHandler
  
  def self.haml_handler
    @@haml_handler ||= ActionView::Template.registered_template_handler(:haml)
  end
  
  def self.call(template)
    puts template.locals.inspect
    haml = "Haml::Engine.new(#{template.source.inspect}).render"
    #if template.locals.include? :mustache
      "Mustache.render(#{haml}, #{template.locals[0]}).html_safe"
    #else
    #  haml.html_safe
    #end
    
  end  
end  

ActionView::Template.register_template_handler(:mustache, MustacheTemplateHandler)