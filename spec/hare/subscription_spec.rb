describe Hare::Subscription do
  describe '.subscribe' do
    it 'watches a queue' do
      result = nil
      Hare::Subscription.subscribe queue: 'subscription.test.queue' do |data|
        result = data[:string]
      end

      Hare::Server.channel.default_exchange.publish(
        { string: 'success' }.to_json,
        routing_key: 'subscription.test.queue'
      )

      sleep(0.1)
      expect(result).to eql 'success'
    end

    it 'sets up a durable queue' do
      result = nil

      # The queue must exist first before we send messages to it.
      Hare::Subscription.create_queue('subscription.test.durablequeue', durable: true)

      # Push the message
      Hare::Server.channel.default_exchange.publish(
        { string: 'success' }.to_json,
        routing_key: 'subscription.test.durablequeue'
      )

      Hare::Server.stop
      Hare::Server.start

      # Re-open the subscription to the queue
      Hare::Subscription.subscribe queue: 'subscription.test.durablequeue', durable: true do |data|
        result = data[:string]
      end

      sleep(0.1)
      expect(result).to eql 'success'
    end

    it 'sets up a binding to a named exchange' do
      result = nil
      Hare::Subscription.subscribe bind: 'named_exchange' do |data|
        result = data[:string]
      end
      Hare::Server.channel.direct('named_exchange').publish(
        { string: 'success' }.to_json
      )

      sleep(0.1)
      expect(result).to eql 'success'
    end
  end
end
