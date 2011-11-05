[Jeff Kreeftmeijer](http://jeffkreeftmeijer.com") talked about [Cucumber](http://cukes.info/)
and [Steak](https://github.com/cavalle/steak) at the last [Amsterdam Ruby
Meetup](http://amsterdam-rb.org/). He hit upon an important theme in software development:
**reducing complexity**; in this case the extra layers of complexity introduced by Cucumber
features and step definitions. And he's absolutely right. If you don't need the natural
language Cucumber provides, then you should get rid of the extra complexity and [use Steak
instead](http://jeffkreeftmeijer.com/2010/steak-because-cucumber-is-for-vegetarians/).

As much as I agree with this, I think there is a way of using Cucumber that makes it a valid option
to use it in more cases than you think. It's for doing Behavior Driven Development with a high focus
on the problem you're trying to solve. Let me explain what I mean by this.

### Using steak for integration tests

Most examples of Cucumber use the [web
steps](https://github.com/aslakhellesoy/cucumber-rails/blob/master/templates/install/step_definition
s/capybara_steps.rb.erb) that the generator of cucumber-rails provides. These are fairly low level:
click a link, fill in some fields, submit and check the outcome. Writing features like this is easy.
All the parts are present by default, so you can get some work done quickly. But if you do it like
this, there is no reason why you should use Cucumber. You're adding complexity (features and step
definitions) which don't add anything compared to Steak.

In fact, Ruby is a very clean language, and the [Capybara](https://github.com/jnicklas/capybara/)
API is very clean too. Even if you have a customer that wants to read your features, they can
read and write for Steak as well, with very little extra effort. So, if you're only in it for the
integration testing, Cucumber will only make your life more complex. And we don't want this extra
complexity, unless there is a good reason for it.

### On behavior and implementation

But there is more to writing acceptance tests, or doing BDD and TDD. One of the more interesting
parts is to discover the design of your code (or the structure of your application). To do this in
unit tests, you need to focus on **behavior**, rather than implementation.

For example: this means that you don't want to test if the results are an empty array, but you
should just test that it is empty. The fact that you happened to have implemented this with an array
is not important.

``` ruby
it { should == []    } # bad: testing implementation
it { should be_empty } # good: testing the behavior
```

The same is true for Cucumber. But here we mostly care about the behavior for the feature. Not the
fact that you happened to have implemented it as a website with links and buttons. Take a look at
the very first example the [RSpec book](http://www.pragprog.com/titles/achbd/the-rspec-book) gives
of Cucumber:

``` feature
Feature: pay bill on-line
  In order to reduce the time I spend paying bills
  As a bank customer with a checking account
  I want to pay my bills on-line

  Scenario: pay a bill
    Given checking account with $50
    And a payee named Acme
    And an Acme bill for $37
    When I pay the Acme bill
    Then I should have $13 remaining in my checking account
    And the payment of $37 to Acme should be listed in Recent Payments
```

There are no implementation details here. No following links, no filling in fields, no pressing
buttons. This is in my opinion the biggest reason to use Cucumber. It focusses you to towards what
you are actually trying to achieve. The step definitions are here to fill in the details.

When you use Cucumber this way, it opens the way for real BDD. You're describing what you want
to achieve, not *how* you want to achieve it. This is in my opinion the unique selling point of
Cucumber. It's a very nice framework to separate the implementation from your intention. **Focussing
on your intentions (in a way that can be automated) is the essence of BDD.**

### But why do this in a natural language?

You could also do this with Steak of course. It's just Ruby, so you could add some code to hide some
of the details to helper methods. And because it is Ruby, you're probably tempted to do it earlier
than with Cucumber. You are now programming, so your programming instincts will come in to play,
making the features clean and simple. We do this all the time. So why should you write in a natural
language?

You're doing it human language, so write it down in the same way you are talking about it. Think
about how you would explain using the website to the stakeholder of the feature. It doesn't matter
that the stakeholder doesn't care about your nifty cucumber features. How would (s)he explain it to
you?

Also, the natural language is closer to your understanding of the problem you're trying to
solve. When I write in code, my programmer side becomes active. My programmer side is focussed
on solutions. But I want to **delay the solution** as long as I can, until we have a decent
understanding of the problem. So by not writing in code, you can focus more on the problem, rather
than on the solution.

Cucumber provides a hard boundary. Your intent is in the feature files, your implementation is
in step definitions. And it is helpful in doing this too; it provides you with the right step
definition when it encounters something that it doesn't know yet. It's really easy to keep the
feature files clean and simple. I will grant you that organizing your step definitions requires a
fair bit of OCD.

Make no mistakes about it: it isn't easy. It's very hard to figure out the right way of describing
your problem, using the right language and in such a way that Cucumber can make sense of it too.
But that is what is to be expected. If your problem is hard, than trying to figure out what your
problem entails and describing it in a way that isn't ambiguous, should to be hard too. But you
should make the effort to really get the language right, because **the implementation that follows
will reflect the way you've described it earlier**. And besides, if it wasn't hard, than it wouldn't
be interesting, now would it?

### Closing thoughts

I'm not saying that you shouldn't use Steak. You should test your application from start to finish,
from top to bottom. I don't care what tools you use, as long as you **test all the fucking time**.
If one of these tools is keeping you from doing that, than you shouldn't use it. If you find writing
Cucumber features depressing, then obviously you shouldn't use it. These tools are here to help us,
not the other way around.

That being said, I think Cucumber can help me in coming up with the right solution to the problem,
documenting what my application is all about and testing it, all at the same time. I like that and
that's why I'll continue to use Cucumber, even for my own projects where I am the only one reading
the features.

And remember, when doing BDD with Cucumber: "When you’re writing a new scenario, I recommend
you start with the formulation of the desired outcome. Write the Then steps first. Then
write the When step to discover the action/operation and finally write the Given steps
that need to be in place in order for the When/Then to make sense." (from the [Cucumber
wiki](https://github.com/aslakhellesoy/cucumber/wiki/))

### More information

Looking around to see other people writing Cucumber stories is very educational. Have a
look at [RSpec's features on Relish](http://relishapp.com/rspec/). On writing good steps,
you should read up on [cuking it wrong](http://elabs.se/blog/15-you-re-cuking-it-wrong) and
[cuking it right](http://mislav.uniqpath.com/2010/09/cuking-it-right/). Also, Hashrocket has an
[interesting discussion online](http://hashrocket.com/blog/view/cucumber-at-hashrocket-bookclub/)
about how they use Cucumber. Jeff Kreeftmeijer wrote [a great introduction on
Steak](http://jeffkreeftmeijer.com/2010/steak-because-cucumber-is-for-vegetarians/). And finally,
the [RSpec book](http://www.pragprog.com/titles/achbd/the-rspec-book) is really gives a good insight
into how to use Cucumber the right way.

Also, Dan North wrote a lengthy article on [how to write
stories](http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/), making a similar point.
