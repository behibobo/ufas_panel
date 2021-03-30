class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(user)
    @user = user
    ActivationMailer.sample_email(@user).deliver_later
  end
end
