#!/usr/bin/env ruby

guard 'rspec', :version => 2, :cli => "--tag ~slow" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^web/(.+)\.rb$}) { |m| "spec/web/#{m[1]}_spec.rb" }
end

guard 'compass', :configuration_file => ".compass.rb" do
  watch(%r{^styles/(.*)\.s[ac]ss$})
end

guard 'rack', :port => 3000 do
  watch('Gemfile.lock')
  watch(%r{^(lib|web)/.*\.rb$})
end
