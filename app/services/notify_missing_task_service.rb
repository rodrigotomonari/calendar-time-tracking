class NotifyMissingTaskService
  attr_accessor :notify_date

  def initialize(notify_date)
    self.notify_date = notify_date
  end

  def call
    return if notify_date.sunday? || notify_date.saturday?

    User.where(notify_missing_tasks: true).where('status = ?', :active).each do |user|
      tasks = user.tasks.where('started_at BETWEEN ? AND ?',
                               notify_date.beginning_of_day, notify_date.end_of_day)

      NotifierMailer.missing_tasks(user, notify_date).deliver_now if tasks.size.zero?
    end
  end
end
