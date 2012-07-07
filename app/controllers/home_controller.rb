class HomeController < ApplicationController
  def index

    if current_user
      redirect_to dashboard_path and return
    end
  end
end
