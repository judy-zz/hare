ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
original_process = Process.pid

SimpleCov.start do
  add_filter "spec/dummy"
end

SimpleCov.at_exit do
  if Process.pid == original_process
    SimpleCov.result.format!
  end
end

# This loads the dummy Rails environment.
require File.expand_path('../dummy/config/environment', __FILE__)

require 'hare'
require 'timecop'
require 'helpers/capture_output'

RSpec.configure do |config|
  if config.files_to_run.one?
    config.full_backtrace = true
    # config.formatter = 'documentation' if config.formatters.none?
  end

  # # Turn this on to profile the slowest tests.
  # config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
