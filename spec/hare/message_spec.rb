describe Hare::Message do

  describe ".exchange" do
    it "sets and returns the exchange variable" do
      dummy_class = Class.new(Hare::Message) do
        exchange "test"
      end
      expect(dummy_class.exchange).to eql "test"
    end
    it "returns :default_exchange if exchange hasn't been set." do
      dummy_class = Class.new(Hare::Message)
      expect(dummy_class.exchange).to eql :default_exchange
    end
  end

  describe ".queue" do
    it "sets and returns the exchange variable" do
      dummy_class = Class.new(Hare::Message) do
        queue "test"
      end
      expect(dummy_class.queue).to eql "test"
    end
  end

  describe ".routing_key" do
    it "sets and returns the exchange variable" do
      dummy_class = Class.new(Hare::Message) do
        routing_key "test"
      end
      expect(dummy_class.routing_key).to eql "test"
    end
  end
  describe "#send" do
    before(:all) do
      Hare::Server.config = {host: "localhost"}
      Thread.new { Hare::Server.start }
      sleep(0.1)
    end

    after(:all) do
      Hare::Server.stop
    end
    context 'with no exchange defined' do
      it "should send a message to the default exchange" do
        dummy_class = Class.new(Hare::Message) do
          queue "testqueue"
        end

        message = dummy_class.new("test")
        expect(message.send) == true
        result = nil

        q = Hare::Server.channel.queue("testqueue")
        q.subscribe do |delivery_info, properties, body|
          result = body
        end

        sleep(0.5) # Give time for the subscription to receive the message.
        expect(result).to eql('"test"')
      end
    end
  end
end
