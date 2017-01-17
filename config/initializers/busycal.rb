Rails.env.on(:development) do
  config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'], port: 3000 }
  config.generators.assets = false
  config.generators.helper = false
  config.generators.test_framework = false
  config.file_watcher = ActiveSupport::FileUpdateChecker

  config.web_console.whiny_requests = false
end

Rails.env.on(:production) do
  config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }
end