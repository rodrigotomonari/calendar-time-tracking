class NotifierMailer < ApplicationMailer
  def missing_tasks(user, date)
    @user    = user

    notify_message = NotifyMessage.offset(rand(NotifyMessage.count)).first

    @message = notify_message.message

    @message.gsub!('%%username%%', @user.name)
    @message.gsub!('%%date%%', I18n.l(date, format: '%d de %B de %Y'))

    mail(to: @user.email, subject: 'Busycal - Notificação')
  end
end
