module Hare
  # <tt>Hare::Message</tt> allows you to send messages to RabbitMQ, and have
  # your exchanges and bindings set up on the fly. Example:
  #
  #   # app/messages/user_message.rb
  #   class UserMessage < Hare::Message
  #     exchange "user.exchange"
  #   end
  #
  #   message = UserMessage.new("data")
  #   message.send
  #
  # Messages are encapsulated in JSON format. If you use
  # <tt>Hare::Subscription</tt> to receive messages, they're automatically
  # parsed back out of JSON into native Ruby objects.
  class Message
    class << self
      def channel
        Hare::Server.channel or fail 'Hare::Server.channel is not open'
      end

      def exchange(name=nil, type: :direct)
        if name.present?
          @type = type
          @exchange = channel.exchange(name, type: type)
        else
          @exchange || channel.default_exchange
        end
      end

      [:direct, :fanout, :topic].each do |type|
        define_method type do |name|
          exchange(name, type: type)
        end
      end

      def routing_key(routing_key = nil)
        if routing_key.present?
          verify_queue(routing_key)
          @routing_key = routing_key
        else
          @routing_key
        end
      end

      def verify_queue(routing_key)
        Hare::Server.channel.queue(routing_key)
      end
    end

    attr_accessor :data
    attr_writer :routing_key

    def initialize(data = nil, routing_key: nil)
      @data = data || {}
      @routing_key = routing_key
    end

    def exchange
      self.class.exchange
    end

    def routing_key
      @routing_key || self.class.routing_key
    end

    def json
      data.present? ? data.to_json : {}.to_json
    end

    def deliver
      if exchange.name == ''
        if routing_key.present?
          exchange.publish(json, routing_key: routing_key)
        else
          fail 'Routing key must be set when using default exchange.'
        end
      else
        exchange.publish(json, routing_key: routing_key)
      end
    end
  end
end
