module TeamHelper

  def self.current_team
    Thread.current[:current_team]
  end

  def self.current_team=(team)
    Thread.current[:current_team] = team
  end
  
  

end
