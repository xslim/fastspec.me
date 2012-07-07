ActiveAdmin.register Package do
  
  form  do |f|
    f.inputs 'Details' do
      f.input :name
    end 
    
    f.inputs 'Features' do
      f.input :features, :as => :select, :input_html => { :multiple => true }, :collection => Feature.all
    end  
    
    f.buttons
  end 

end
