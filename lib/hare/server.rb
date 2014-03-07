require 'logger'

module Hare
  class Server
    attr_reader :status, :connection

    def initialize
      @status = "off"
    end

    def cleanup
      @connection.try(:close)
    end

    def capture_signals
      trap('TERM') do
        say 'Exiting...'
        cleanup
        stop
      end

      trap('INT') do
        say 'Exiting...'
        cleanup
        stop
      end
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

      end
    end
  end
end
