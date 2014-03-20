require 'logger'

module Hare
  module Logger
    DEFAULT_LOG_LEVEL = ::Logger::INFO

    def logger
      Rails.logger ||= ::Logger.new(STDOUT)
      @logger ||= Rails.logger
    end

    def say(text, level = DEFAULT_LOG_LEVEL)
      puts text if @loud
      logger.add level, "HARE: #{text}"
    end
  end
end
