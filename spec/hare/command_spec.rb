require 'pty'

describe Hare::Command do
  context "-h" do
    let(:args) {["-h"]}
    it "replies with help info" do
      output = capture_stdout do
        expect{Hare::Command.new args}.to raise_error SystemExit
      end
      expect(output).to match /There aren't any options yet for the process. When there are, they'll be located here./
    end
  end
end
