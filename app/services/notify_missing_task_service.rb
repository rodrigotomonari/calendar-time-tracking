class NotifyMissingTaskService
  attr_accessor :notify_date, :slack_notifier

  def initialize(notify_date)
    self.notify_date = notify_date

    self.slack_notifier = Slack::Notifier.new(ENV['SLACK_HOOK'], {
      username: 'Busycal',
      icon_emoji: ':ghost:',
      channel: ENV['SLACK_CHANNEL']
    })
  end

  def call
    return if notify_date.sunday? || notify_date.saturday?

    User.where(notify_missing_tasks: true).where('status = ?', :active).each do |user|
      tasks = user.tasks.where('started_at BETWEEN ? AND ?',
                               notify_date.beginning_of_day, notify_date.end_of_day)

      if tasks.size.zero?
        NotifierMailer.missing_tasks(user, notify_date).deliver_now
        if user.slackuser.present?
          slack_notifier.ping "<@#{user.slackuser}> acho que você esqueceu de preencher o Busycal do dia #{I18n.l(notify_date, format: '%d de %B de %Y')}!"
        end
      end
    end
  end
end
