module Hare
  class Subscription
    class << self
      def subscribe(queue:"", bind:nil, &blk)
        queue = Hare::Server.channel.queue(queue)
        queue.bind(bind) if bind.present?
        queue.subscribe do |delivery_info, properties, body|
          data = HashWithIndifferentAccess.new(JSON.parse(body))
          yield(data)
        end
      end
    end
  end
end
