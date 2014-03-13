module Hare
  class Message
    class << self
      def channel
        Hare::Server.channel
      end

      def exchange(exchange=nil, type: :direct)
        if exchange.present?
          @type = type
          @exchange = channel.exchange(exchange, type: type)
        else
          @exchange || channel.default_exchange
        end
      end

      def routing_key(routing_key=nil)
        if routing_key.present?
          @routing_key = routing_key
        else
          @routing_key
        end
      end
    end

    attr_accessor :data

    def initialize(data=nil)
      @data = data || {}
    end

    def channel
      self.class.channel
    end

    def exchange
      self.class.exchange
    end

    def routing_key
      self.class.routing_key
    end

    def json
      data.present? ? data.to_json : {}.to_json
    end

    def send
      if exchange.name == ""
        if routing_key.present?
          exchange.publish(json, routing_key: routing_key)
        else
          raise "Routing key must be set (so we know what queue to send your message to.)"
        end
      else
        exchange.publish(json, routing_key: routing_key)
      end
    end
  end
end
