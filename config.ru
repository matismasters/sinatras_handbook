# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../run.rb',  __FILE__)
run Sinatra::Application
