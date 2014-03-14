require 'hare'
require 'rails'

module Hare
  class Railtie < Rails::Railtie
    generators do
      require "generators/hare/install/install_generator"
      require "generators/hare/install/message_generator"
      require "generators/hare/install/subscription_generator"
    end
  end
end
