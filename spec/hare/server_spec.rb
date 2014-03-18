describe Hare::Server do
  before do
    @server = Class.new(Hare::Server)
    @server.config = {host: "localhost"}
  end
  describe '.status' do
    context 'when the server is not started' do
      it "returns 'off'" do
        expect(@server.status).to eql "off"
      end
    end
    context 'when the server is started' do
      it "returns 'started'" do
        thread = Thread.new { @server.start }
        sleep(0.1)
        expect(@server.status).to eql "started"
        thread.kill
      end
    end
  end

  describe ".stop" do
    it "closes the connection to rabbitmq" do
      @server.start
      expect(@server).to receive(:cleanup)
      @server.stop
    end
  end

  describe ".start" do
    it "opens a connection to rabbitmq" do
      thread = Thread.new { @server.start }
      sleep(0.1)
      expect(@server.connection).to be_kind_of(Bunny::Session)
      thread.kill
    end
  end

  describe ".open_connection" do
    it "opens a connection to rabbitmq" do
      thread = Thread.new { @server.open_connection }
      sleep(0.1)
      expect(@server.connection).to be_kind_of(Bunny::Session)
      thread.kill
    end
  end

  describe ".open_channel" do
    it "opens a channel using the connection to rabbitmq" do
      @server.open_connection
      thread = Thread.new { @server.open_channel }
      sleep(0.1)
      expect(@server.channel).to be_kind_of(Bunny::Channel)
      thread.kill
    end

    it "raises an error if the connection isn't open" do
      expect{ @server.open_channel }.to raise_error
    end
  end
end
