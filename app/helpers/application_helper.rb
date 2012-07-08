module ApplicationHelper
  
  def current_team
    return nil if !current_user

    team = nil

    team_id = session[:team_id]
    if team_id
      team = (current_user.teams.find(team_id) rescue nil)
    end

    if !team
      team = current_user.teams.first
      session[:team_id] = team.id.to_s if team
    end
    
    return team
  end

end
