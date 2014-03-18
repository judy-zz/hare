require 'logger'

module Hare
  # Set up log/hare.log, and (condionally) send messages there and to stdout.
  module Logger
    DEFAULT_LOG_LEVEL = ::Logger::INFO

    def logger
      @logger ||= Rails.logger
    end

    def say(text, level = DEFAULT_LOG_LEVEL)
      puts text if @loud
      logger.add level, "HARE: #{text}"
    end
  end
end
