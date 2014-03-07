describe Hare::Server do
  describe '#status' do
    before { @server = Hare::Server.new }
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

  describe "#capture_signals" do
    it "should capture 'TERM'" do
      @server = Hare::Server.new
      expect(@server).to receive(:cleanup)
      pid = fork do
        @server.start
      end
      sleep(0.1)
      Process.kill("TERM", pid)
    end
  end

  describe "#start" do
    it "opens a connection to rabbitmq" do
      @server = Hare::Server.new
      thread = Thread.new { @server.start }
      sleep(0.1)
      expect(@server.connection).to be_kind_of(Bunny::Session)
      thread.kill
    end
  end
end
