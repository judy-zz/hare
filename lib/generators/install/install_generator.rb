require 'rails/generators'

module Hare
  class InstallGenerator < Rails::Generators::Base
    self.source_paths << File.join(File.dirname(__FILE__), 'templates')

    def create_executable_file
      template "hare", Rails.root + "bin"
      chmod Rails.root + "bin/hare", 0755
    end
  end
end
