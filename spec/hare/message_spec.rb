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
    it "should send a message" do
      message = Hare::Message.new
      message.send
    end
  end
end
