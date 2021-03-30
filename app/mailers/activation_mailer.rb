class ActivationMailer < ApplicationMailer
  default from: "noreply@ufasvpn.com"

  def sample_email(user)
    @user = user
    mail(to: @user.email, subject: "Your actication code is #{@user.activation_code}")
  end
end
