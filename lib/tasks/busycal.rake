namespace :busycal do

  desc 'Notify today missing tasks'
  task :notify_today => :environment do
    NotifyMissingTaskService.new(DateTime.now).call
  end

  desc 'Notify previous weekday missing tasks'
  task :notify_previous_weekday => :environment do
    notify_date = DateTime.yesterday

    if notify_date.sunday?
      notify_date -= 2.days
    elsif notify_date.saturday?
      notify_date -= 1.day
    end

    NotifyMissingTaskService.new(notify_date).call
  end
end
