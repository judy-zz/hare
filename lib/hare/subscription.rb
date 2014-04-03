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
      def channel
        Hare::Server.channel
      end

      def subscribe(queue:'', bind:nil, &blk)
        queue = channel.queue(queue)
        if bind.present?
          ensure_exchange_exists(bind)
          queue.bind(bind)
        end
        queue.subscribe do |delivery_info, properties, body|
          data = HashWithIndifferentAccess.new(JSON.parse(body))
          yield(data)
        end
      end

    private

      def ensure_exchange_exists(bind)
        unless channel.exchanges.keys.find_index(bind)
          channel.exchange(bind, type: :direct)
        end
      end
    end
  end
end
