When using Rails 2.3 and Passenger, you can do yourself a favor by adding this line to <tt>config/silencers/backtrace_silencer.rb</tt>

    Rails.backtrace_cleaner.add_silencer { |line| line =~ /^\s*passenger/ }

Saves you scrolling through the endless backtraces passenger gives you for free :)

PS. A colleague tweeted this <a href="http://twitter.com/pascaldevink/status/2240565349">lovely backtrace</a> of a spring with grails error. I say: backtrace cleaner FTW!
