require 'rails/generators'

module Hare
  # <tt>Hare::MessageGenerator</tt> generates a template of a message file. Change the
  # resulting file with your intended exchange or routing_key information. For example:
  #
  #   rails generate message user_notification
  class MessageGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_message_file
      messages_folder = Rails.root + 'app/messages'
      empty_directory messages_folder
      template 'message.rb', messages_folder + "#{file_name}_message.rb"
    end
  end
end
