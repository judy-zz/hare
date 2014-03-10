require 'logger'

module Hare
  class Server
    DEFAULT_LOG_LEVEL = Logger::INFO
    attr_reader :status, :connection, :quiet

    def initialize
      @status = "off"
      @logger = Rails.logger
      @quiet = true
    end

    def set_status(string)
      @status = string
      say "Status changed to #{@status}"
    end

    def say(text, level = DEFAULT_LOG_LEVEL)
      puts text unless quiet
      @logger.add level, "#{Time.now.strftime('%FT%T%z')}: #{text}"
    end

    def cleanup
      @connection.try(:close)
      set_status("off") if @connection.nil?
    end

    def capture_signals
      trap('TERM') { close }
      trap('INT') { close }
    end

    def close
      say 'Exiting...'
      cleanup
      exit
    end

    def open_connection
      @connection ||= Bunny.new
      @connection.start
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
