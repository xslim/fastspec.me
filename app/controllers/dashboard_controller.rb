class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    
    @team = current_team

    if !@team
      redirect_to new_team_path and return
    end

    @projects = @team.projects
    #@projects = @projects.collect { |e| e if (current_user.has_role?(:write, e) || current_user.has_role?(:read, e)) }

  end

end
