module Hare
  class InstallGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../../../templates', __FILE__)

    def create_executable_file
      template "hare", Rails.root + "bin"
      chmod Rails.root + "bin/hare", 0755
    end
  end
end
