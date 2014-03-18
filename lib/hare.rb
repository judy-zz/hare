$:.unshift File.expand_path(File.dirname(__FILE__))

require 'bunny'

require 'hare/version'
require 'hare/logger'
require 'hare/server'
require 'hare/message'
require 'hare/subscription'

require 'hare/railtie'
