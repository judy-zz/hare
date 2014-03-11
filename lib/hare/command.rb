require 'daemons'
require 'optparse'

module Hare
  # Hare::Command takes care of command parsing, and starting the Hare::Server process. A lot of
  # this code is derivative of how DelayedJob does it, because DJ does it so well.
  class Command

    def initialize(args)
      @options = {
        :pid_dir => "#{Rails.root}/tmp/pids"
      }

      opts = OptionParser.new do |opts|
        opts.banner = <<END
Usage: #{File.basename($0)} [options] start|stop|restart|run
There aren't any options yet for the process. When there are, they'll be located here.
END
        opts.on('-h', '--help', 'Show this message') do
          puts opts
          exit 1
        end
      end
      @args = opts.parse!(args)
    end

    def daemonize
      dir = @options[:pid_dir]
      Dir.mkdir(dir) unless File.exists?(dir)
      run_process(dir)
    end

    def run_process(dir)
      Daemons.run_proc("hare", dir: dir, dir_mode: :normal, monitor: false, ARGV: @args) {|*args| run }
    end

    def run
      Dir.chdir(Rails.root)
      server = Hare::Server.new
      server.start
    rescue => e
      Rails.logger.fatal e
      STDERR.puts e.message
      exit 1
    end

  end
end
