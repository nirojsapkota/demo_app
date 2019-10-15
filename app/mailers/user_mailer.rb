class UserMailer < ApplicationMailer
  default from: 'noreply@demo.com'

  def imported_successfully
    @filename = params[:filename]
    mail(to: 'user@mail.com', subject: 'Data imported successfully')
  end
end
