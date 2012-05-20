#!/usr/bin/env ruby

require 'guard/guard'
module ::Guard
  class Shotgun < ::Guard::Guard

    def initialize(watchers, options = {})
      super
      system "shotgun -p #{options.fetch(:port)} -o 0.0.0.0 &"
    end

    def run_all
    end

    def run_on_change(paths)
    end

  end
end

guard 'rspec', :version => 2, :cli => "--tag ~slow" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^web/(.+)\.rb$}) { |m| "spec/web/#{m[1]}_spec.rb" }
end

guard 'shotgun', :port => 3000
