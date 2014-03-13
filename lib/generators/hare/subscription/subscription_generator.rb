require 'rails/generators'

module Hare
  class SubscriptionGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_message_file
      subscriptions_folder = Rails.root + "app/subscriptions"
      empty_directory subscriptions_folder
      template 'subscription.rb', subscriptions_folder + "#{file_name}_subscription.rb"
    end
  end
end
