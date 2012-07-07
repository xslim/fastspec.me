class Api::V1::FeaturesController < ::Api::ApiController
  
  def get
    
    @features = Feature.all()
    puts @features
  end
  
  def add
    
    
    
  end
  
end  