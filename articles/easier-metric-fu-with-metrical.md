title: Easier MetricFu with Metrical
publish: 2010-11-27

---

**TL;DR:** I've just released **[metrical](http://github.com/iain/metrical)**. It is a tiny wrapper around metric_fu.


MetricFu is awesome. It helps me keep my code clean by identifying problem spots in my code. Unfortunately, it's difficult to get running. MetricFu requires to be run with Rake. But by doing that, it becomes part of your project's dependencies. Especially if you're using Bundler.

### Enter Metrical

Metrical is a wrapper around MetricFu, that allows it to be run as an executable on any project. Just install it, and run it. No setup or adjustments to your project should be required. It's that easy!

    cd /path/to/project/
    gem install metrical
    metrical

If you want to configure MetricFu, you can add a file called <tt>.metrics</tt>, in which you can add your regular configuration. For all configuration options, you can visit the <a href="http://metric-fu.rubyforge.org">MetricFu homepage</a>. All I've done is add a small tweak to the rcov options, so it'll run RSpec without problems.

So, give it a spin and tell me what you think of it!
