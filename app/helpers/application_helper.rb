module ApplicationHelper
  
  def image_tag(source, options={})
    super(source, options) if source.present?
  end

  def icon_link_to(icon, hint, url, html_options = {})
    html_options.merge!({title: hint, rel: 'tooltip', class: 'hint'})

    link_to(url, html_options) do
      raw("<i class=\"icon-#{icon}\"></i>")
    end
  end

end
