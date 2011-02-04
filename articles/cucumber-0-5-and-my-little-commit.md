The strangest thing happened to me this week. I was working on a little side project at work. It seemed like a nice time to try out some new gems (<a href="http://gemcutter.org/gems/bundler">Bundler</a> and <a href="http://gemcutter.org/gems/devise">Devise</a>: love it! <a href="http://gemcutter.org/gems/inherited_resources">InheritedResources</a>, not that much, <a href="http://gemcutter.org/gems/formtastic">Formtastic</a>, very nice). I was experimenting with <a href="http://cukes.info">Cucumber</a> and writing Dutch features too.

I had figured that the supplied dutch keywords in <tt><a href="http://github.com/aslakhellesoy/cucumber/blob/master/lib/cucumber/languages.yml#L328-340">languages.yml</a></tt> were not very practical. It supplied "<em>Gegeven</em>" as a naive translation of "<em>Given</em>". Although this is correctly translated, it is very unpractical to form Dutch sentences with it. The only to really start a sentence with "<em>Gegeven</em>" is to write "<em>Gegeven het feit dat...</em>" ("<em>Given the fact that...</em>"). It's very strange to say "<em>Gegeven dat ik een profiel heb</em>" ("<em>Given I have a profile</em>") in Dutch.

I decided to use the synonym "<em>Stel</em>" like in "<em>Stel ik heb een profiel</em>". Not entirely correct either because it misses a comma after "<em>Stel</em>", but much better, in my honest opinion. So I forked cucumber, changed <tt>languages.yml</tt> and used this as custom git repository in my <tt>Gemfile</tt>.

Apparently I was in the middle of a Release Candidate, so what I had committed on github. The Rails integration was extracted out in that version (like RSpec does) to the "<a href="http://github.com/aslakhellesoy/cucumber-rails">cucumber-rails</a>" gem. This gave about an evening of confusion, but I got it to work eventually.

Two days later, we had visitors at our company, from another Ruby company, talking about cooperation on future projects. I introduced myself and he was trying to remember if he'd seen anything on the interwebs by me. That seems to be common. When meeting people on conferences it's always the same question: "Do I know any of your gems?".

Anyway, he had actually read my name recently, namely in the commit log of cucumber. Without asking or sending a pull request, they had added my commit to the 0.5 release of cucumber. A pleasant surprise! Aslak Hellesøy, you're a very observant <a href="http://github.com/aslakhellesoy">GitHub user</a>!

By the way, you can still use "<em>Gegeven</em>", as it is just an alias.

I am constantly wrestling with the best way write cucumber features down. Does anyone have Dutch features? Do you write them down with your customers or are they for developers only? Can you share some of them? Here are some of mine:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">
<font color="#96cbfe">Scenario:</font>&nbsp;Inloggen
&nbsp;&nbsp;<font color="#6699cc">Stel</font>&nbsp;ik ben uitgelogd
&nbsp;&nbsp;<font color="#6699cc">En</font>&nbsp;ik heb een account voor &quot;gebruiker@test.com&quot; met het wachtwoord &quot;geheim&quot;
&nbsp;&nbsp;<font color="#6699cc">En</font>&nbsp;ik ben op de inlogpagina
&nbsp;&nbsp;<font color="#ffd2a7">Als</font>&nbsp;ik de volgende velden invul:
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#00a0a0">|</font>&nbsp;E-mailadres <font color="#00a0a0">|</font>&nbsp;gebruiker@test.com&nbsp;&nbsp;<font color="#00a0a0">|</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#00a0a0">|</font>&nbsp;Wachtwoord&nbsp;&nbsp;<font color="#00a0a0">|</font>&nbsp;geheim&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#00a0a0">|</font>
&nbsp;&nbsp;<font color="#ffd2a7">En</font>&nbsp;ik op &quot;Inloggen&quot; druk
&nbsp;&nbsp;<font color="#ffd2a7">Dan</font>&nbsp;zie ik de melding &quot;Je bent ingelogd&quot;

<font color="#96cbfe">Scenario:</font>&nbsp;Verkeerd wachtwoord
&nbsp;&nbsp;<font color="#6699cc">Stel</font>&nbsp;ik ben uitgelogd
&nbsp;&nbsp;<font color="#6699cc">En</font>&nbsp;ik heb een account voor &quot;gebruiker@test.com&quot; met het wachtwoord &quot;geheim&quot;
&nbsp;&nbsp;<font color="#6699cc">En</font>&nbsp;ik ben op de inlogpagina
&nbsp;&nbsp;<font color="#ffd2a7">Als</font>&nbsp;ik de volgende velden invul:
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#00a0a0">|</font>&nbsp;E-mailadres <font color="#00a0a0">|</font>&nbsp;gebruiker@test.com&nbsp;&nbsp;<font color="#00a0a0">|</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#00a0a0">|</font>&nbsp;Wachtwoord&nbsp;&nbsp;<font color="#00a0a0">|</font>&nbsp;verkeerd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#00a0a0">|</font>
&nbsp;&nbsp;<font color="#ffd2a7">En</font>&nbsp;ik op &quot;Inloggen&quot; druk
&nbsp;&nbsp;<font color="#ffd2a7">Dan</font>&nbsp;zie ik de foutmelding &quot;Ongeldig e-mailadres of wachtwoord&quot;</pre>

<img src="http://iain.nl/wp-content/uploads/2009/12/achbd-150x150.jpg" alt="The RSpec Book" title="The RSpec Book" width="150" height="150" class="alignright size-thumbnail wp-image-575" />By the way, don't forget to order the <a href="http://pragprog.com/titles/achbd/the-rspec-book">RSpec and Friends book</a>. It'll be released this februari and is a really good read if you want to learn BDD, RSpec or Cucumber.