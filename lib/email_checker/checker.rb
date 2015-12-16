module EmailChecker
  class Checker
    attr_reader :domain

    def initialize(email)
      @email = email
      email_m = email.match(EMAIL_PATTERN)
      @domain = Domain.new(email_m[2])
    end

    def email_exists_in_server?
      mailfrom(EmailChecker.config.verifier_domain) if EmailChecker.config.verifier_domain
      rcptto(@email).tap do
        close_connection
      end
    end

    private

      def smtp
        return @smtp if @smtp
        domain.mx_servers.each do |server|
          @smtp = Net::SMTP.start(server[:address], 25, EmailChecker.config.verifier_domain)
          return @smtp if @smtp
        end
        fail EmailChecker::ServerConnectionError, "Unable to connect to any of the mail servers for #{@email}"
      rescue EmailVerifier::ServerConnectionError => e
        fail EmailChecker::ServerConnectionError, e.message
      rescue => e
        retry
      end

      def mailfrom(address)
        ensure_250(smtp.mailfrom(address))
      end

      def rcptto(address)
        ensure_250(smtp.rcptto(address))
      rescue => e
        if e.message[/^550/]
          return false
        else
          fail EmailVerifier::FailureError, e.message
        end
      end

      def ensure_250(smtp_return)
        return true if smtp_return.status.to_i == 250
        fail EmailVerifier::FailureError, "Mail server responded with #{smtp_return.status} when we were expecting 250"
      end

      def close_connection
        smtp.finish if smtp && smtp.started?
      end
  end
end
