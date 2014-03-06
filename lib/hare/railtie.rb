require 'hare'
require 'rails'

module Hare
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      # After Rails is initialized, stuff will run here. Eventually.
    end
  end
end
