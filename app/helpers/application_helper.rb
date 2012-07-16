module ApplicationHelper
  
  def image_tag(source, options={})
    super(source, options) if source.present?
  end

  def icon_link_to(icon, body, url, html_options = {})
    link_to(url, html_options) do
      raw("<i class=\"icon-#{icon}\" style=\"opacity:0.8;padding-right:5px;\"></i>#{body}")
    end
  end

  def icon_hint_link_to(icon, hint, url, html_options = {})
    html_options.merge!({title: hint, rel: 'tooltip', class: 'hint'})

    link_to(url, html_options) do
      raw("<i class=\"icon-#{icon}\" style=\"opacity:0.8\"></i>")
    end
  end

end
