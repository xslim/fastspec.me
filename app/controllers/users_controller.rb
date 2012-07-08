class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.in_team
  end

  def show
    @user = User.in_team.find(params[:id])
  end

end
