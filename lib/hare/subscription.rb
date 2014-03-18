module Hare
  class Subscription
    class << self
      def channel
        Hare::Server.channel
      end

      def subscribe(queue:"", bind:nil, &blk)
        queue = channel.queue(queue)
        if bind.present?
          channel.exchange(bind, type: :direct)
          queue.bind(bind)
        end
        queue.subscribe do |delivery_info, properties, body|
          data = HashWithIndifferentAccess.new(JSON.parse(body))
          yield(data)
        end
      end
    end
  end
end
