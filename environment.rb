require 'sinatra'
require 'haml'
require 'rdiscount'
require 'builder'
require 'yaml'
require 'cgi'

ROOT = File.expand_path('..', __FILE__)

Dir.glob(File.join(ROOT, "lib/**/*.rb")).each { |file| require file }
