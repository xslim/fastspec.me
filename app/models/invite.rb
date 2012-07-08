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
  field :accepted, :type => Boolean

  def self.find_by_email(email)
    self.first(conditions: { email: email} )
  end

  def self.exists_for(for_id, for_type, email)
    self.first(conditions: { invited_for: for_id, invited_for_type: for_type, email: email} )
  end

  def ensure_token
    self.token ||= Devise.friendly_token[0,20]
  end

end
