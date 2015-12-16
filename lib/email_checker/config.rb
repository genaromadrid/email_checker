module EmailChecker
  module Config
    class << self
      attr_accessor :verifier_email,
                    :test_mode
      attr_reader :verifier_domain

      def reset
        @verifier_email = 'nobody@nonexistant.com'
        @verifier_domain = @verifier_email.split('@').last
        @test_mode = false
        if defined?(Rails) && defined?(Rails.env) && Rails.env.test?
          @test_mode = true
        end
      end

      def verifier_email=(verifier_email)
        @verifier_email = verifier_email
        @verifier_domain = verifier_email.split('@').last
      end
    end

    self.reset
  end
end
