class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      UserMailer.welcome_email(user).deliver_later
    end
  end
end
