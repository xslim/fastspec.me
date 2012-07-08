class ApplicationController < ActionController::Base
  protect_from_forgery


  def current_team
    return nil if !current_user

    team = nil

    team_id = session[:team_id]
    if team_id
      team = (current_user.teams.find(team_id) rescue nil)
    end

    if !team
      team = current_user.teams.first
      session[:team_id] = team.id.to_s
    end
    
    return team
  end

  def set_current_team(team)
    session[:team_id] = team.id.to_s
  end

end
