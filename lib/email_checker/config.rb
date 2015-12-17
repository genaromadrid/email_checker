module EmailChecker
  module Config
    class << self
      attr_accessor :verifier_email,
                    :test_mode
      attr_reader :verifier_domain

      def reset
        @verifier_email = nil
        @test_mode = false
        @test_mode = true if defined?(Rails) && defined?(Rails.env) && Rails.env.test?
      end

      def verifier_email=(verifier_email)
        @verifier_email = verifier_email
        @verifier_domain = verifier_email.split('@').last
      end
    end

    reset
  end
end
