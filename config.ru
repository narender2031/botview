# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'rubygems'
require 'bundler'


# Bundler.require

# require File.join(File.dirname(__FILE__), 'my_sinatra_app.rb')

# map '/' do
  run Rails.application
# end

# map '/api' do
#   run Sinatra::Application
# end

