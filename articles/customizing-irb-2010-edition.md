**TL;DR**: Check out my new [`.irbrc`-file](http://github.com/iain/osx_settings/blob/master/.irbrc)!

Customizing my work environment is a nerdish hobby of mine. I spend far to much time tweaking my terminal. While I'll save my terminal customizations for another time, I'll show you my IRB tweaks in this post.

There are several tools to improve your IRB, and some of them have been around for ages. But the arrival of [Bundler](http://gembundler.com/) makes it difficult to use them. Bundler creates a bubble in which you have to specify your dependencies explicitly. Furthermore, with project specific gemsets, provided by the ever so awesome [RVM](http://rvm.beginrescueend.com/), we need to install these IRB extensions for every project.

This means that you cannot be sure that extensions like Wirble are available in your new and shiny Rails console. There is only one way around that: add them to your Gemfile. This is what I usually add:

<pre class="ir_black" style="background: #000000; color: #f6f3e8;"><!-- you're looking at ir_black colorscheme exported by macvim, I don't write my HTML like this AT ALL, seriously!  But, why in FSM's name are you reading my source? --><font face="Monaco, Courier new, monospace"><font color="#96cbfe">group</font>&nbsp;<font color="#99cc99">:development</font>&nbsp;<font color="#6699cc">do</font>
&nbsp;&nbsp;<font color="#96cbfe">gem</font>&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">wirble</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;<font color="#96cbfe">gem</font>&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">hirb</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;<font color="#96cbfe">gem</font>&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">awesome_print</font><font color="#336633">&quot;</font>, <font color="#99cc99">:require</font>&nbsp;=&gt; <font color="#336633">&quot;</font><font color="#a8ff60">ap</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;<font color="#96cbfe">gem</font>&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">interactive_editor</font><font color="#336633">&quot;</font>
<font color="#6699cc">end</font></font></pre>

### Extension Loading

To load the IRB extensions without blowing up in your face when they're not available, I gently try to load them, and configure them only when that is successful. [You can download my `.irbrc` on github](http://github.com/iain/osx_settings/blob/master/.irbrc). Here is what it looks like:

<figure class="ir_black"><img src="/irb.png" alt="" title="irb" width="737" height="188"></figure>

When you start IRB, it shows a line with the extensions loaded. If it's gray, it's not appropriate (like rails2 in this example), loaded extensions are green and extensions that are not available are in red.

### Showing Queries in ActiveRecord 3

As you can see, the queries done by ActiveRecord are displayed in the same way as they are displayed in your log files. In Rails 2, you would've done this by redirecting the log output to `STDOUT`. In Rails 3 you need to subscribe to the '`sql.active_record`'-notifications.

This could in theory also be done for other Rails 3 compatible ORMs like Mongoid, but I haven't looked into that yet.

### Hirb

[Hirb](http://tagaholic.me/hirb/) formats objects into pretty tables, as you can see in the picture above. It also provides some scrolling possibilities like the command line tools less and more. Very handy!

### Wirble

The first IRB extension anyone uses. [Wirble](http://pablotron.org/software/wirble/) provides you with history and syntax highlighting.

### Awesome Print

While Wirble colorizes the output to improve readability, it can get cluttered really fast, especially when you're dealing with nested hashes and arrays. [AwesomePrint](http://github.com/michaeldv/awesome_print) helps to untangle your object mess:

<figure class="ir_black"><img src="/awesomeprint.png" alt="" title="awesomeprint" width="278" height="150"></figure>

### Print Methods

The '`pm`'-extension I found [on the intertubes](http://snippets.dzone.com/posts/show/2916) some time ago, lists the methods and what arguments they take on any given object. You can filter it, by providing a regex. This is what it looks like:

<figure class="ir_black"><img src="/pm.png" alt="" title="pm" width="324" height="138"></figure>

It's not a gem, but a snippet pasted directly into my irbrc, so it's always available.

### Interactive Editor

Open vim (or any other editor) from IRB, edit your code, save it, close your editor and the code gets executed. Open vim again and your code is visible and editable again. Very awesome! [Check it out](http://github.com/jberkel/interactive_editor)!

### More

Yeah, there more. There's [bond](http://tagaholic.me/2009/07/16/bond-from-irb-with-completion-love.html), which makes autocompletion better, and [utility belt](http://utilitybelt.rubyforge.org/), and more. I can't remember to use them all, so I haven't included them into my irbrc. They certainly are cool enough for you to check out! Also, a lot of great tips are [here on Stack Overflow](http://stackoverflow.com/questions/123494/whats-your-favourite-irb-trick).

If you have any good tips, please share them! Oh, and the other OSX tweaks I use are on [github](http://github.com/iain/osx_settings).

PS. For those that don't know how to load this: put the `.irbrc` file in your home directory and it will load automatically.
