class User::UpdateUser
  attr_reader :type, :message, :user_id
  
  def initialize(type, message, user_id)
    @type = type
    @message = message
    @user_id = user_id.to_i
  end

  def perform
    user = User.find_by(id: user_id)
    if user.present?
      user.update(name: message) if type == "name"
      user.update(email: message) if type == "email"
      user.update(password: message) if type == "password"
      return "User is updated"
    else
      rise error "User not found!"
    end
  end

end