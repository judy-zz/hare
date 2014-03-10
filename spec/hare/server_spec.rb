describe Hare::Server do
  before { @server = Hare::Server.new }
  describe '#status' do
    context 'when the server is started' do
      it "returns 'started'" do
        thread = Thread.new { @server.start }
        sleep(0.1)
        expect(@server.status).to eql "started"
        thread.kill
      end
    end
    context 'when the server is not started' do
      it "returns 'off'" do
        expect(@server.status).to eql "off"
      end
    end
  end

  describe "#say" do
    it "sends the message to standard out if @quiet is false" do
      @server.instance_variable_set(:@quiet, false)
      expect(STDOUT).to receive(:puts).with("test")
      @server.say("test")
    end

    it "sends the message to the log file" do
      Timecop.freeze do
        expect(Rails.logger).to receive(:add).with(1, "#{Time.now.strftime('%FT%T%z')}: test")
        @server.say("test")
      end
    end
  end

  describe "#capture_signals" do
    it "captures 'TERM'" do
      pid = fork do
        expect(@server).to receive(:cleanup)
        @server.start
      end
      sleep(0.1)
      Process.kill("TERM", pid)
    end

    it "captures 'INT'" do
      pid = fork do
        expect(@server).to receive(:cleanup)
        @server.start
      end
      sleep(0.1)
      Process.kill("INT", pid)
    end
  end

  describe "#start" do
    it "opens a connection to rabbitmq" do
      thread = Thread.new { @server.start }
      sleep(0.1)
      expect(@server.connection).to be_kind_of(Bunny::Session)
      thread.kill
    end
  end
end
