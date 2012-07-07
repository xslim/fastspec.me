class ApplicationController < ActionController::Base
  protect_from_forgery


  def current_team
    return nil if !current_user

    team_id = session[:team_id]
    #@teams = current_user.teams
    
    team = (team_id) ? current_user.teams.find(team_id) : current_user.teams.first
    return (team) ? team : nil
  end

end
