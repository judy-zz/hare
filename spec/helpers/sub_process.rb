# Adapted from https://raw.github.com/rspec/rspec-support/master/lib/rspec/support/spec/in_sub_process.rb
# Useful as a way to isolate a global change to a subprocess.
def in_sub_process
  readme, writeme = IO.pipe

  pid = Process.fork do
    exception = nil
    begin
      yield
    rescue Exception => e
      exception = e
    end

    writeme.write Marshal.dump(exception).force_encoding("ISO-8859-1").encode("UTF-8") if exception

    readme.close
    writeme.close
    exit! # prevent at_exit hooks from running (e.g. minitest)
  end

  writeme.close
  Process.waitpid(pid)

  exception = Marshal.load(readme.read)
  readme.close

  raise exception if exception
end
