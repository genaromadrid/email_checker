require 'resolv'
require 'email_checker/version'

module EmailChecker
  autoload :Config, 'email_checker/config'
  autoload :Checker, 'email_checker/checker'
  autoload :Domain, 'email_checker/domain'

  EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  SERVER_TIMEOUT = 5000

  def self.check(email, verifier_email=nil)
    config.verifier_email = verifier_email if verifier_email
    checker = EmailChecker::Checker.new(email)
    return false unless checker.domain.valid?
    checker.email_exists_in_server?
  end

  def self.config
    if block_given?
      yield(EmailChecker::Config)
    else
      EmailChecker::Config
    end
  end
end
