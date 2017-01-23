Rails.env.on(:development) do
  config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'], port: 3000 }
  config.generators.assets = false
  config.generators.helper = false
  config.generators.test_framework = false
  config.file_watcher = ActiveSupport::FileUpdateChecker

  config.web_console.whiny_requests = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => '127.0.0.1', :port => 1025 }
end

Rails.env.on(:production) do
  config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV['SMTP_HOST'],
    port:                 ENV['SMTP_PORT'],
    domain:               ENV['SMTP_DOMAIN'],
    user_name:            ENV['SMTP_USER'],
    password:             ENV['SMTP_PASS'],
    authentication:       'plain',
    enable_starttls_auto: true
  }
  config.action_mailer.raise_delivery_errors = false
end
