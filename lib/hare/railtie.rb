require 'hare'
require 'rails'

module Hare
  class Railtie < Rails::Railtie
    initializer "hare" do
      Hare::Server.start

      # Eagerly load messages and subscriptions so they have time to create the necessary AMQP structures.
      matcher = /\A#{Regexp.escape(Rails.root.to_s)}\/(.*)\.rb\Z/
      eagerloads = []
      eagerloads.concat(Dir.glob("#{Rails.root}/app/messages/**/*.rb"))
      eagerloads.concat(Dir.glob("#{Rails.root}/app/subscriptions/**/*.rb"))

      eagerloads.sort.each do |file|
        require_dependency file.sub(matcher, '\1')
      end
    end
  end
end
