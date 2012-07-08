class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def new

    if !current_team
      redirect_to root_path, alert: 'Please select team!' and return
    end

    puts ""

    @invite = Invite.new

  end

  def create

    email = params[:invite][:email]
    if email && email.empty?
      redirect_to new_invite_path, alert: 'Please provide valid email!' and return
    end

    invited_for_type = current_team.class.to_s
    invited_for = current_team.id.to_s

    if Invite.exists_for(invited_for, invited_for_type, email)
      redirect_to new_invite_path, alert: 'Invite already sent' and return
    end

    @invite = Invite.new(params[:invite])
    @invite.invited_for_type = invited_for_type
    @invite.invited_for = invited_for
    @invite.invited_by_type = current_user.class.to_s
    @invite.invited_by = current_user.id.to_s

    if @invite.save

      # Make bool
      emailed = (UserMailer.invite_to_team(email, current_team, @invite).deliver rescue false)
      if emailed
        @invite.emailed = emailed
        @invite.save
      end

      redirect_to root_path, notice: 'Invite was successfully created.' and return
    end
    redirect_to new_invite_path
  end

  def join_team
    #stub
    redirect_to root_path, notice: 'Successfully joined new team!' and return
  end

end
