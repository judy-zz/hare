describe Hare::Message do
  describe '.exchange' do
    it 'sets and returns the exchange' do
      dummy_class = Class.new(Hare::Message) do
        exchange 'test', type: :direct
      end
      expect(dummy_class.exchange.name).to eql 'test'
      expect(dummy_class.exchange.type).to eql :direct
    end
    it "returns the default exchange if exchange hasn't been set." do
      dummy_class = Class.new(Hare::Message)
      expect(dummy_class.exchange.name).to eql ''
      expect(dummy_class.exchange.type).to eql :direct
    end
  end

  describe '.routing_key' do
    it 'sets and returns the routing_key variable' do
      dummy_class = Class.new(Hare::Message) do
        routing_key 'test'
      end
      expect(dummy_class.routing_key).to eql 'test'
    end
  end

  describe '#send' do
    it 'raises an error if nothing is defined' do
      dummy_class = Class.new(Hare::Message)

      message = dummy_class.new('test')
      expect { message.send }.to raise_error
    end

    it 'sends a message to the default exchange' do
      dummy_class = Class.new(Hare::Message) do
        routing_key 'testkey'
      end

      message = dummy_class.new('test')
      message.send
      result = nil

      Hare::Server.channel.queue('testkey').subscribe do |delivery_info, properties, body|
        result = body
      end

      sleep(0.1)
      expect(result).to eql('"test"')
    end

    it 'sends a message to a named exchange' do
      dummy_class = Class.new(Hare::Message) do
        exchange 'direct-test-exchange', type: :direct
      end

      q = Hare::Server.channel.queue('')
      q.bind('direct-test-exchange')
      message = dummy_class.new('data')
      message.send
      result = nil

      q.subscribe do |delivery_info, properties, body|
        result = body
      end

      sleep(0.1)
      expect(result).to eql('"data"')
    end
  end
end
