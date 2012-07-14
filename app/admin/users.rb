# ActiveAdmin.register User do
#   menu :if => proc{ current_user.has_role?(:superadmin) }
  
#   index do
#     column :name
#     column :email
#     column :last_sign_in_at
#     default_actions
#   end

#   form do |f|
#     f.inputs "Details" do
#       f.input :name
#       f.input :email
#       f.input :password
#       f.input :password_confirmation
      
#     end
    
#     f.buttons
#   end

# end
