module Hare
  # <tt>Hare::Subscription</tt> allows you to automatically receives messages
  # from RabbitMQ, and run a block of code upon receiving each new message.
  # Queues and bindings are set up on the fly. Subscriptions are also eagerly
  # loaded by Rails, so they're defined when the Rails environment is loaded.
  # Example:
  #
  #   # app/messages/user_message.rb
  #   class UserSubscription < Hare::Subscription
  #     subscribe(bind: "user.exchange") do |data|
  #       puts data
  #     end
  #   end
  #
  # Messages are depacked from JSON, into plain old Ruby objects. If you use
  # <tt>Hare::Message</tt> to send messages, it automatically encapsulates
  # messages into JSON to make the process easier.
  class Subscription
    class << self
      include Hare::Logger

      def channel
        Hare::Server.channel
      end

      def subscribe(queue:'', bind:nil, &blk)
        create_queue(queue)
        create_binding(bind)
        @queue.subscribe do |delivery_info, properties, body|
          yield format_data(body)
        end
      end

      # This creates a random queue if the queue supplied is an empty string.
      def create_queue(queue)
        @queue = channel.queue(queue)
      end

      def create_binding(bind)
        if bind.present?
          ensure_exchange_exists(bind)
          @queue.bind(bind)
        end
      end

    private

      def ensure_exchange_exists(bind)
        unless channel.exchanges.keys.find_index(bind)
          channel.exchange(bind, type: :direct)
        end
      end

      def format_data(body)
        obj = JSON.parse(body)
        HashWithIndifferentAccess.new(obj)
      rescue
        say "JSON data wasn't received, returning plain object"
        body
      end
    end
  end
end
