I have a big test suite in the current Rails application I'm working on. I have 2340 examples in RSpec, taking over 2 minutes to run. This is an absolute pain to run. Luckily there is autotest (or autospec if you're running RSpec, like I am), which tests only the changed files. I've grown to be totally dependent on this behavior, and I can't imagine programming without it anymore.

I also do TDD, which means that I write a failing test first, and then program until it passes. But Autotest's flow is that, once you've fixed a failing test or spec, it reruns the entire the suite to see if you're solution doesn't have any side effects. Normally this is fine, but with this kind of test suite, I cannot afford to wait for it to complete.

So, after going through Autotest's code, I've decided to stub out this behavior. You can still trigger a complete rerun of the entire suite by pressing Ctrl+C, but it doesn't do that every time you go green. It's a bit of a monkey patch, but it works just right.

The autotest-growl gem clears the terminal. I don't like that, because I like to see a bit of history. That's why I changed that behavior too.

Here's my `~/.autotest` file:

    # Use file system hooks on OS X
    require 'autotest/fsevent'

    # Don't run entire test suite when going from red to green
    class Autotest
      def tainted
        false
      end
    end

    # Use Growl support
    require 'autotest/growl'

    # Don't clear the terminal, when using Growl
    module Autotest::Growl
      @@clear_terminal = false
    end

While browsing through the code of Autotest I also found that it also looks for a `.autotest` file in the current working directory. So if you want to apply these changes to one project only, you can define this file locally for the project. I didn't know that!
