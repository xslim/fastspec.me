class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def new

    if !current_team
      redirect_to root_path, alert: 'Please select team!' and return
    end

    puts "#{APP_CONFIG.inspect}"

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
    @invite.active = true

    if @invite.save

      if send_invite(@invite.token)
        redirect_to root_path, notice: 'Invite was successfully created.' and return
      else
        redirect_to root_path, alert: 'Invite problem!' and return
      end
    end
    redirect_to new_invite_path and return
  end

  def reinvite
    send_invite(params[:token])
    redirect_to root_path, notice: 'Invite re-sended.' and return
  end

  def join

    invite = Invite.find_by_token(params[:token])

    if !invite
      redirect_to root_path, alert: 'Non existing invite!' and return
    elsif !invite.active
      redirect_to root_path, alert: 'Invite expired!' and return
    end

    invited_for = (Kernel.const_get(invite.invited_for_type).find(invite.invited_for) rescue nil)
    if !invited_for
      redirect_to root_path, alert: 'Invite problem!' and return
    end

    # not generic now
    invited_for.users << current_user
    invited_for.save

    set_current_team invited_for

    invite.update_attributes(active: false)
    redirect_to root_path, notice: 'Successfully joined new team!' and return
  end

  def send_invite(token)

    invite = Invite.find_by_token(params[:token])
    invited_for = (Kernel.const_get(invite.invited_for_type).find(invite.invited_for) rescue nil)
    if !invited_for
      return false
      #redirect_to root_path, alert: 'Invite problem!' and return
    end

    # Make bool
    #emailed = UserMailer.invite_to_team(email, current_team, @invite).deliver
    emailed = (UserMailer.invite_to_team(invite.email, invited_for, invite).deliver rescue false)
    if emailed
      invite.mailed = emailed
      invite.save
    end

    return true
  end

end
