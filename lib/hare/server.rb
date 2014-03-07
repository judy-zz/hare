module Hare
  class Server
    attr_reader :status, :connection

    def initialize
      @status = "off"
    end

    def cleanup
      @connection.try(:close)
      @status = "off" if @connection.nil?
    end

    def capture_signals
      trap('TERM') { close }
      trap('INT') { close }
    end

    def close
      puts 'Exiting...'
      cleanup
      exit
    end

    def open_connection
      @connection ||= Bunny.new
      @connection.start
    end

    def start
      @status = "starting"
      capture_signals
      open_connection
      @status = "started"

      loop do
        # TODO: Ensure the connection stays open, and re-open it if it closes. Or fail loudly.
      end
    end
  end
end
