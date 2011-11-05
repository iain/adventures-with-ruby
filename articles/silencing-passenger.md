When using Rails 2.3 and Passenger, you can do yourself a favor by adding this line to
`config/silencers/backtrace_silencer.rb`

``` ruby
Rails.backtrace_cleaner.add_silencer { |line| line =~ /^\s*passenger/ }
```

Saves you scrolling through the endless backtraces passenger gives you for free :)

PS. A colleague tweeted this [lovely backtrace](http://twitter.com/pascaldevink/status/2240565349)
of a spring with grails error. I say: backtrace cleaner FTW!
