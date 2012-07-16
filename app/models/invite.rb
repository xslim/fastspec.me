class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  before_save :ensure_token

  field :token, :type => String
  field :email, :type => String
  field :invited_by, :type => String
  field :invited_by_type, :type => String
  field :invited_for, :type => String
  field :invited_for_type, :type => String

  field :mailed, :type => Boolean
  field :active, :type => Boolean
  #field :accepted, :type => Boolean

  def self.find_by_email(email)
    self.find_by(email: email)
  end

  def self.find_by_token(token)
    self.find_by(token: token)
  end

  def self.exists_for(for_id, for_type, email)
    self.find_by(invited_for: for_id, invited_for_type: for_type, email: email)
  end

  def ensure_token
    self.token ||= Devise.friendly_token[0,20]
  end

end
