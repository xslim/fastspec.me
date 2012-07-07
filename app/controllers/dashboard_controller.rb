class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    
    @team = current_team

    if !@team
      redirect_to new_team_path and return
    end

  end

end
