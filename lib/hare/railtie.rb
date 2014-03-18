require 'hare'
require 'rails'

module Hare
  class Railtie < Rails::Railtie
    initializer "hare" do
      Hare::Server.start
    end
  end
end
