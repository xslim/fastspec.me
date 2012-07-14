# ActiveAdmin.register Package do
#   menu :if => proc{ current_user.has_role?(:superadmin) }
  
#   form  do |f|
#     f.inputs 'Details' do
#       f.input :name
#     end 
    
#     f.inputs 'Features' do
#       f.input :features, :as => :select, :input_html => { :multiple => true }, :collection => Feature.all
#     end  
    
#     f.buttons
#   end

#   show :title => proc{ package.name } do
#     attributes_table do
#       row :name
#     end
    
#     panel "Features" do
#       table_for(package.features) do |t|
#         t.column("Image") {|o| image_tag(o.image.small_thumb) if o.image? }
#         t.column("Feature") {|o| auto_link o }
#         t.column("Estimate") {|o| o.estimate }
#       end
#     end
        
#   end

# end
