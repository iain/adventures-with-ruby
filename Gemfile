#!/usr/bin/env ruby
source :rubygems

group :production do
  gem 'sinatra'
  gem 'slim'
  gem 'builder'
end

group :development do
  gem 'shotgun'
  gem 'heroku'
end

group :styles do
  gem 'sass', '>= 3.2.0.alpha.237'
  gem 'compass'
end

group :articles do
  gem 'redcarpet'
  gem 'nokogiri'
end

group :guard do
  gem 'guard-rspec'
  gem 'guard-compass'
end

group :test do
  gem 'rspec'
  gem 'spec_coverage'
  gem 'rack-test'
  gem 'nokogiri'
end
