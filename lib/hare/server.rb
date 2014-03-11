module Hare
  class Server
    include Hare::Logger
    attr_reader :status, :connection, :quiet

    def initialize
      @status = "off"
      @quiet = true
    end

    def set_status(string)
      @status = string
      say "Status changed to #{@status}"
    end

    def cleanup
      @connection.close
      set_status "off"
    end

    def capture_signals
      trap('TERM') { close('TERM') }
      trap('INT') { close('INT') }
    end

    def close(signal='TERM')
      cleanup
      raise SignalException.new(signal)
    end

    def open_connection
      @connection ||= Bunny.new
      @connection.start
      say "Connection open."
    end

    def start
      set_status "starting"
      capture_signals
      open_connection
      set_status "started"

      loop do
        # TODO: Ensure the connection stays open, and re-open it if it closes. Or fail loudly.
      end
    end
  end
end
