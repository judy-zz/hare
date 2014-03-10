$:.unshift File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hare/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = 'hare'
  s.version       = Hare::VERSION
  s.authors       = ['Clinton Judy']
  s.email         = ['clinton@j-udy.com']
  s.summary       = 'Rails plugin for RabbitMQ'
  s.description   = 'This is a Rails plugin that makes it easier for your models to communicate via AMQP to RabbitMQ.'
  s.license       = 'ISC'

  s.files         = `git ls-files -z`.split("\x0")
  s.test_files    = s.files.grep(/spec\//)
  s.require_paths = %w[lib]

  s.add_dependency 'railties', '~> 4.0'
  s.add_dependency 'bunny', '~> 1.1.3'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rails', '~> 4.0.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.0.0.beta1'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-livereload'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'simplecov'
end
