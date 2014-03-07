describe Hare::Server do
  describe '#status' do
    context 'when the server is started' do
      it "returns 'started'" do
        @server = Hare::Server.new
        thread = Thread.new { @server.start }
        sleep(0.1)
        expect(@server.status).to eql "started"
        thread.kill
      end
    end
    context 'when the server is not started' do
      it "returns 'off'" do
        @server = Hare::Server.new
        expect(@server.status).to eql "off"
      end
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
