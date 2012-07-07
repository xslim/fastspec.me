ActiveAdmin.register Feature do
  
  form  do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :description
      f.input :estimate #hours
    end
    f.inputs "Image" do
      if feature.image?
        f.input :image, :as => :file, :input_html => { :style => "display:none;" }, :hint => f.template.image_tag(feature.image.thumb)
        f.input :remove_image, :as => :boolean
      else
        f.input :image
      end
    end
    f.inputs 'Packages' do
      f.input :packages, :as => :select, :input_html => { :multiple => true }, :collection => Package.all
    end 
  
    f.buttons
  end  

end
