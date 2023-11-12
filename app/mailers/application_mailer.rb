class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_DOMAIN']
  layout 'mailer'
end
