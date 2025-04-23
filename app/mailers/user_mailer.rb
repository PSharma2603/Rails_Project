class UserMailer < ApplicationMailer
    default from: 'your-sender-email@sandbox92f456eaa3fb4bb48aab077c219fd312.mailgun.org'
  
    def welcome_email(user)
      @user = user
      mail(to: @user.email, subject: 'Welcome to Technova Store!')
    end
  end
  