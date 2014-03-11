describe Hare::Logger do
  class DummyClass; end

  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_class.extend(Hare::Logger)
  end

  describe "#say" do
    it "sends the message to standard out if @quiet is false" do
      @dummy_class.instance_variable_set(:@quiet, false)
      expect(STDOUT).to receive(:puts).with("test")
      @dummy_class.say("test")
    end

    it "sends the message to the log file" do
      Timecop.freeze do
        expect(@dummy_class.logger).to receive(:add).with(1, "test")
        @dummy_class.say("test")
      end
    end
  end

end
