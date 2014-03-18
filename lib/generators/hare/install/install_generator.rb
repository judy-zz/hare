require 'rails/generators'

module Hare
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def create_amqp_config_file
      filepath = Rails.root + "config"
      template "amqp.yml.sample", filepath + "amqp.yml.sample"
      append_file Rails.root + '.gitignore', 'config/amqp.yml'
    end
  end
end
