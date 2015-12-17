require 'net/smtp'

module EmailChecker
  class Checker
    attr_reader :domain

    def initialize(email)
      @email = email
      email_m = email.match(EMAIL_PATTERN)
      @domain = Domain.new(email_m[2])
    end

    def email_exists_in_server?
      mailfrom if EmailChecker.config.verifier_domain
      rcptto.tap do
        close_connection
      end
    ensure
      close_connection
    end

    private

      def smtp
        return @smtp if @smtp
        domain.mx_servers.each do |server|
          @smtp = connect(server[:address])
          break if @smtp
        end
        fail EmailChecker::ServerConnectionError, "Unable to connect to any of the mail servers for #{@email}"
      end

      def connect(address)
        Net::SMTP.start(address, 25, EmailChecker.config.verifier_domain)
      rescue => e
        raise EmailChecker::FailureError, e.message
      end

      def mailfrom
        ensure_250(smtp.mailfrom(EmailChecker.config.verifier_email))
      end

      def rcptto
        ensure_250(smtp.rcptto(@email))
      rescue => e
        if e.message[/^550/]
          return false
        else
          raise EmailChecker::FailureError, e.message
        end
      end

      def ensure_250(smtp_return)
        return true if smtp_return.status.to_i == 250
        fail EmailChecker::FailureError, "Mail server responded with #{smtp_return.status} when we were expecting 250"
      end

      def close_connection
        smtp.finish if smtp && smtp.started?
      end
  end
end
