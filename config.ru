$:.unshift(File.expand_path('../lib', __FILE__))
require 'application'
run Sinatra::Application
