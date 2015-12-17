module EmailChecker
  class Domain
    def initialize(domain)
      @domain = domain
    end

    # Checks if the domian exists and has valid MX and A records
    #
    # @return [type] [description]
    def valid?
      return false unless @domain
      Timeout.timeout(SERVER_TIMEOUT) do
        return true if valid_mx_records?
        return true if a_records?
      end
    rescue Timeout::Error, Errno::ECONNREFUSED
      false
    end

    # Check if it has valid MX records and it can receive emails.
    # The MX server exists and it has valid A records.
    #
    # @return [Boolean]
    def valid_mx_records?
      mx_servers.each do |server|
        exchange_a_records = dns.getresources(server[:address], Resolv::DNS::Resource::IN::A)
        return true if exchange_a_records.any?
      end
      false
    end

    # Check if the domain exists validation that has at least 1 A record.
    #
    # @return [Boolean]
    def a_records?
      a_records.any?
    end

    def a_records
      @a_records ||= dns.getresources(@domain, Resolv::DNS::Resource::IN::A)
    end

    def mx_records
      @mx_records ||= dns.getresources(@domain, Resolv::DNS::Resource::IN::MX).sort_by(&:preference)
    end

    def mx_servers
      return @mx_servers if @mx_servers
      @mx_servers = []
      mx_records.each do |mx|
        @mx_servers.push(preference: mx.preference, address: mx.exchange.to_s)
      end
      @mx_servers
    end

    private

      def dns
        @dns ||= Resolv::DNS.new
      end
  end
end
