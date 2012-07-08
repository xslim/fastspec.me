module ApplicationHelper
  
  def image_tag(source, options={})
    super(source, options) if source.present?
  end

end
