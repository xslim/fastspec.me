class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :comment, :type => String
  field :user_name, :type => String
  field :user_id, :type => String
  field :user_email, :type => String
  
  embedded_in :project_feature
  
end  