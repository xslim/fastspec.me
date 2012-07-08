class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :preset_current_team

  include TeamHelper

  #def current_team
  #  TeamHelper.current_team
  #end

  def set_current_team(team)
    session[:team_id] = team.id.to_s
  end
  
  def after_sign_out_path_for(resource_or_scope)
    #reset_session
    session[:team_id] = nil
    root_path
  end


  def preset_current_team
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
    
    TeamHelper.current_team = team
  end

end
