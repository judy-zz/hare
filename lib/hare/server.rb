module Hare
  class Server
    class << self
      include Hare::Logger

      attr_reader :connection, :channel, :loud
      attr_accessor :config

      def set_status(string)
        @status = string
        say "Status changed to #{@status}"
      end

      def status
        @status || "off"
      end

      def cleanup
        @connection.close
        set_status "off"
      end

      def capture_signals
        trap('TERM') { close('TERM') }
        trap('INT') { close('INT') }
      end

      def load_config
        @config = YAML.load_file(Rails.root + "config/amqp.yml")[Rails.env]
        say "Loaded config."
      end

      def close(signal='TERM')
        cleanup
        raise SignalException.new(signal)
      end

      def open_connection
        @connection ||= Bunny.new(@config)
        if @connection.start
          say "Opened connection: #{@connection}"
        end
      end

      def open_channel
        if @connection.present?
          @channel = @connection.create_channel
          say "Opened channel: #{@channel}"
        else
          raise "Connection needs to be opened before opening a channel."
        end
      end

      def start
        set_status "starting"
        capture_signals
        load_config unless @config.present?
        open_connection
        open_channel
        set_status "started"

        loop do
          sleep(5.0)
        end
      end

      def stop
        set_status "stopping"
        cleanup
      end
    end
  end
end
