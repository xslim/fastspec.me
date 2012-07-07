class Api::V1::FeaturesController < ::Api::ApiController
  
  def list
    
    @features = Feature.all
    
  end
  
end  