I've been working on a very rapid implemented website with Rails this week. It has been an exiting week. It all started on a Monday, when I overslept, and my colleague ([Arie](http://ariekanarie.nl)) smiled at me and said: "You'll be working with me this week". I liked the idea. Since we started working there we both worked on our own Rails projects, but never together. He continued: "You know the *Leven Als* website? It's deadline has been changed... to this week, preferably to yesterday!" That certainly was a challenge. I knew that the functional and graphical designers had been working on it for quite some time, but I've never heard of it ever coming to the implementation phase. Three quarters of the HTML were done and we had 4 days to start a Ruby project from scratch and make it.<!--more-->

Luckily we were assured by the project manager: "This is an easy website. People enter the website, choose which prize they want to win, enter some data and that's it. Nothing big, because there are no users having to log in." After drawing up a rudimentary class diagram I found out that a website without users is in fact quite hard! You can invite more than one person to the company (a big Dutch insurance company), you have to insure that all it's invites becomes linked to the same person for letting him have more chance of winning the prize. We had to fake logged in users and all relations that user had, put it all into a session, but still use the database on every form to utilize the validation ActiveRecord gives us.

Speaking of testing, we're quite fans of Behavior Driven Development, using Rspec and user stories and such, but we had no time for it. We are going to write some specs and acceptance tests next week, after the website goes live, hopefully finding no big bugs after that. With a few managers looking down on our shoulders every few hours, the pressure was on to come up with as much functionality in a short amount of time.  Thus making the [Dilbert way of Agile development](http://www.dilbert.com/comics/dilbert/archive/images/dilbert2666700071126.gif) a reality.

Still there was a black hole of productivity lurking. What would cost us the most time, was implementing the HTML. For years, any decent IT company has it's own designing team with HTML template makers and all. These people know a lot about all the quirks of this horribly abused markup language, and spit out giant blobs of static pages representing each page of the application. And although it looks pretty, for a developer in Rails, it's a nightmare of converting that into Rails views, templates and partials. Every image tag, label, form element and so on needed to be looked at, replaced or altered. With no consideration of how difficult javascript can be, dropdowns magically interacting with the page are added. A button, described with "doing the obvious thing", would have to do all kinds of fancy Ajax stuff, being as nice as your everyday Google-application. Designers never think about error messages, where they should go and how your application should deal with unexpected behaviour.  By far the worst thing is that you'll be given the entire CSS every time, so you had to dig through it to find changes, convert it again and implement it.

But, despite of it all, I like the outcome. Everyone did their best, everyone with a bit of HTML knowledge stepped in to help, to make the deadline. It was definitely worth it!

**Update:** Leven is now live on [http://www.levenals.nl/](http://www.levenals.nl/)

Here are some stats:
<pre>
+----------------------+-------+-------+---------+---------+-----+-------+
| Name                 | Lines |   LOC | Classes | Methods | M/C | LOC/M |
+----------------------+-------+-------+---------+---------+-----+-------+
| Controllers          |   244 |   204 |       4 |      20 |   5 |     8 |
| Helpers              |    19 |    16 |       0 |       1 |   0 |    14 |
| Models               |   215 |   167 |       7 |      20 |   2 |     6 |
| Libraries            |     0 |     0 |       0 |       0 |   0 |     0 |
| Integration tests    |     0 |     0 |       0 |       0 |   0 |     0 |
| Functional tests     |    24 |    18 |       3 |       3 |   1 |     4 |
| Unit tests           |    61 |    46 |       7 |       7 |   1 |     4 |
+----------------------+-------+-------+---------+---------+-----+-------+
| Total                |   563 |   451 |      21 |      51 |   2 |     6 |
+----------------------+-------+-------+---------+---------+-----+-------+
  Code LOC: 387     Test LOC: 64     Code to Test Ratio: 1:0.2</pre>
