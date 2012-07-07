# TODO: fix this
class LoggedInConstraint < Struct.new(:value)
  def matches?(request)
    request.cookies.key?("user_token") == value
  end
end