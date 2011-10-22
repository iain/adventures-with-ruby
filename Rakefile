task :default => :rspec


desc "Runs the tests"
task :rspec do
  require 'rspec'
  require 'rspec/autorun'
  $:.unshift(File.dirname(__FILE__))
  Dir["spec/**/*_spec.rb"].each { |f| require f }
end
