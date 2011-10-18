$:.unshift(File.expand_path('../lib', __FILE__))
$:.unshift(File.expand_path('../web', __FILE__))
require 'application'
run Sinatra::Application
