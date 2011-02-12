<strong>Updated October 10th, 2008 to be up to date with Rails 2.2 RC1 release.</strong>

With Rails 2.2 releasing any day now, I want to show you how to translate ActiveRecord related stuff. It is quite easy, once you know where to keep your translations. Here is a complete guide to using all built in translation methods!

<strong>Contents:</strong>

<ol>
  <li><a href="#scenario">Scenario</a></li>
  <li><a href="#setting-up">Setting up</a></li>
  <li><a href="#models">Translating models</a></li>
  <li><a href="#attributes">Translating attributes</a></li>
  <li><a href="#default-validations">Translating default validations</a></li>
  <li><a href="#interpolation">Interpolation in validations</a></li>
  <li><a href="#model-specific">Model specific messages</a></li>
  <li><a href="#attribute-specific">Attribute specific messages</a></li>
  <li><a href="#defaults">Defaults</a></li>
  <li><a href="#error_messages_for">Using error_messages_for</a></li>
  <li><a href="#conclusion">Conclusion</a></li>
</ol>

<!--more-->

<h3 id="scenario">Scenario</h3>

Suppose we're building a forum. A forum has several types (e.g. admin) of users and suppose we want to make the most important users into separate models using Single Table Inheritance (sti). This gives us the most complete scenario in showing off all translations:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">User</font>&nbsp;&lt; <font color="#ffffb6">ActiveRecord</font>::<font color="#ffffb6">Base</font>
&nbsp;&nbsp;validates_presence_of <font color="#99cc99">:name</font>, <font color="#99cc99">:email</font>, <font color="#99cc99">:encrypted_password</font>, <font color="#99cc99">:salt</font>
&nbsp;&nbsp;validates_uniqueness_of <font color="#99cc99">:email</font>, <font color="#99cc99">:message</font>&nbsp;=&gt; <font color="#99cc99">:already_registered</font>
<font color="#96cbfe">end</font>

<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Admin</font>&nbsp;&lt; <font color="#ffffb6">User</font>
&nbsp;&nbsp;validate <font color="#99cc99">:only_men_can_be_admin</font>
<font color="#6699cc">private</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">only_men_can_be_admin</font>
&nbsp;&nbsp;&nbsp;&nbsp;errors.add(<font color="#99cc99">:gender</font>, <font color="#99cc99">:chauvinistic</font>, <font color="#99cc99">:default</font>&nbsp;=&gt; <font color="#336633">&quot;</font><font color="#a8ff60">This is a chauvinistic error message</font><font color="#336633">&quot;</font>) <font color="#6699cc">unless</font>&nbsp;gender == <font color="#336633">'</font><font color="#a8ff60">m</font><font color="#336633">'</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

<h3 id="setting-up">Setting up</h3>

Make sure you're running Rails 2.2 or Rails edge (<tt>rake rails:freeze:edge</tt>)

Now let's translate all this into <a href="http://icanhascheezburger.com" target="_blank">LOLCAT</a>, just for fun. We need a directory to place the locale files:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">mkdir app/locales</pre>

And we need to load all files as soon as the application starts. So we make an initializer:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#7c7c7c"># config/initializers/load_translations.rb</font>
<font color="#336633">%w{</font><font color="#a8ff60">yml rb</font><font color="#336633">}</font>.each <font color="#6699cc">do</font>&nbsp;|<font color="#c6c5fe">type</font>|
&nbsp;&nbsp;<font color="#ffffb6">I18n</font>.load_path += <font color="#ffffb6">Dir</font>.glob(<font color="#336633">&quot;</font><font color="#00a0a0">#{</font><font color="#ffffb6">RAILS_ROOT</font><font color="#00a0a0">}</font><font color="#a8ff60">/app/locales/**/*.</font><font color="#00a0a0">#{</font>type<font color="#00a0a0">}</font><font color="#336633">&quot;</font>)
<font color="#6699cc">end</font>
<font color="#ffffb6">I18n</font>.default_locale = <font color="#336633">'</font><font color="#a8ff60">LOL</font><font color="#336633">'</font></pre>

This approach is recommended, because loading files is not something you want to do during the request, when it should already be available. Setting you're locale like this is probably not recommended, but it's easy, if you're just using one language.

<h3 id="models">Translating models</h3>

Next, we're going to make some simple translation files. All ActiveRecord translations need to be in the activerecord scope. So when starting your locale file, it starts with the locale name, followed by the scope.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#c6c5fe">LOL</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">activerecord</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">models</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">user</font><font color="#00a0a0">:</font>&nbsp;kitteh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">admin</font><font color="#00a0a0">:</font>&nbsp;Ceiling cat</pre>

Let's try this out in <tt>script/console</tt>

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">
>> User.human_name
=> "kitteh"
>> Admin.human_name
=> "Ceiling cat"
</pre>

It's nice to know that the method <tt>human_name</tt> is used by error messages in validations too. But we'll come to that in just a second.

If you didn't specify the translation of admin, it would have used the translation of user, because it inherited it.

<h3 id="attributes">Translating attributes</h3>

We could append to the same file, but I choose to make a new file, because it keeps this post clean and it's a bit easier to see how the scoping works.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#c6c5fe">LOL</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">activerecord</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">attributes</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">user</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">name</font><font color="#00a0a0">:</font>&nbsp;naem
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">email</font><font color="#00a0a0">:</font>&nbsp;emale</pre>

And let's try this again:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">
>> User.human_attribute_name("name")
=> "naem"
>> Admin.human_attribute_name("email")
=> "emale"
</pre>

Once again, you can see that single table inheritance helps us with this.

Both human_name and human_attribute cannot really fail, because if no translation has been specified, it would return the normal humanized version. So if you're making an English site, you don't really need to translate models and attributes.

<h3 id="default-validations">Translating default validations</h3>

Let's translate a few default messages:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#c6c5fe">LOL</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">activerecord</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">errors</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">messages</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">blank</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;can not has nottin&quot;</font>
</pre>


<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">
>> u = User.new
=> #<User id: nil, etc>
>> u.valid?
=> false
>> u.errors.on(:name)
=> "can not has nottin"
</pre>

<h3 id="interpolation">Interpolation in validations</h3>

You have more freedom in your validation messages now. With every message you can interpolate the translated name of the model, the attribute and the value. The variable 'count' is also available where applicable (e.g. <tt>validates_length_of</tt>)

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#c6c5fe">LOL</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">activerecord</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">errors</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">messages</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">already_registered</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;u already is {{model}}&quot;</font>
</pre>

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">
>> u.errors.on(:email)
=> "u already is kitteh"
</pre>

Remember to put quotes around the translation key in yaml, because it'll fail without it, when using the interpolation brackets.

<h3 id="model-specific">Model specific messages</h3>

A message specified in the activerecord.errors.models scope overrides the translation of this kind of message for the entire model.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#c6c5fe">LOL</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">activerecord</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">errors</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">messages</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">blank</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;can not has nottin&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">models</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">admin</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">blank</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;want!&quot;</font></pre>

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">
>> u.errors.on(:name)
=> "can has nottin"
>> a = Admin.new
=> #<Admin id: nil, etc>
>> a.valid?
=> false
>> a.errors.on(:salt)
=> "want!"
</pre>


<h3 id="attribute-specific">Attribute specific messages</h3>

Any translation in the activerecord.errors.models.model_name.attributes scope overrides model specific attribute- and default messages.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#c6c5fe">LOL</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">activerecord</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">errors</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">models</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">admin</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">blank</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;want!&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">attributes</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">salt</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">blank</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;is needed for cheezburger&quot;</font></pre>

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">
>> a.errors.on(:name)
=> "want!"
>> a.errors.on(:salt)
=> "is needed for cheezburger"
</pre>

<h3 id="defaults">Defaults</h3>

When you specify a symbol as the default option, it will be translated like a normal error message, just like you've seen with <tt>:already_registered</tt>. When default hasn't been found, it'll try looking up the normal key you have given. With <tt>:already_registered</tt>, that key has already been set by Rails, because we're using <tt>validates_uniqueness_of</tt>.

When you specify a string as default value, it'll use this when no translations have otherwise been found.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">
>> a.gender = 'f'
=> "f"
>> a.valid?
=> false
>> a.errors.on(:gender)
=> "This is a chauvinistic error message"
</pre>

<h3 id="error_messages_for">Using error_messages_for</h3>

When you want to display the error messages in a model in a view, most people will user error_messages_for. These messages are also translated. The message has a header and a single line, saying how many errors there are. Here are the default English translations of these messages. I will leave it up to you to translate it to LOLCAT. Win a lifetime supply of cheezburgerz* with this mini-competition ;)

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">en<font color="#ffffff">-</font><font color="#c6c5fe">US</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">activerecord</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">errors</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">template</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">header</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">one</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;1 error prohibited this {{model}} from being saved&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">other</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;{{count}} errors prohibited this {{model}} from being saved&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">body</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;There were problems with the following fields:&quot;</font></pre>

There is one slight problem with the messages it displays. <tt>error_messages_for</tt> uses the <tt>errors.full_messages</tt> in it's list. This means that the attribute names will be put before it. Of course these will be translated with <tt>human_attribute_name</tt>, but it might not always be desirable. In other languages than English it's sometimes hard to formulate a nice error message with the attribute name at the beginning. This will have to be fixed in later Rails versions.

<h3 id="conclusion">Conclusion</h3>

I hope you'll agree with me that these translation options for ActiveRecord are really nice! This is what we have been waiting for. Too bad I was a bit too late with my adjustments, so form labels don't translate by default. I did build it, but Rails was already feature frozen by then. I will probably post a plugin that adds this functionality. Same goes for a i18n version of scaffold.

Please keep coming back to my site, or add the RSS feed to your favorite reader.

Of course, stay in touch with the <a href="http://groups.google.com/group/rails-i18n" target="_blank">i18n mailinglist</a>. A lot of people are putting a lot of effort into the project. New plugins and gems solving problems problems rapidly. I18n is one of the more difficult things to do, so if you have a special insight in a language, please contribute!

<strong>Happy devving!</strong>

PS. Damn! I wish I was in <a href="http://en.oreilly.com/railseurope2008/public/content/home" target="_blank">Berlin</a> right now!


<p style="font-size: 40%">* invisible cheezburgerz only</p>

<h3>Update</h3>

This post is old. Still, after 2 years, it still accounts for 10% of my daily traffic. How cool is that?
Seriously though, read the <a href="http://guides.rubyonrails.org/i18n.html">official Rails guide</a> on this subject, for up to date information!
