class Hare::Message
  class << self
    def exchange(exchange=nil)
      if exchange.present?
        @exchange = exchange
      else
        @exchange || :default_exchange
      end
    end

    def queue(queue=nil)
      if queue.present?
        @queue = queue
      else
        @queue
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

  def send
    json = data.to_json
    Hare::Server.channel.default_exchange.publish(json, routing_key: self.class.queue)
  end
end
