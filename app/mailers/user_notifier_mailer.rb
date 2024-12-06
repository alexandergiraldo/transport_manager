class UserNotifierMailer < ApplicationMailer

  # send a signup email to the user, pass in the user object that contains the user's email address
  def send_signup_email(user)
    @user = user
    @plates = Vehicle.where(id: user.all_vehicle_ids).pluck(:license_plate)
    mail(
      :to => @user.email,
      :subject => 'Bienvenido a TranspoControl' )
  end
end