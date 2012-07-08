class UserMailer < ActionMailer::Base
  default from: "fastspec@appfellas.co"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.invite_to_team.subject
  #
  def invite_to_team(email, team, invite)
    @team_id = team.id.to_s
    @team_name = team.name
    @invite_token = invite.token

    mail to: email, subject: "Join team #{@team_name} in FastSpec"
  end
end
