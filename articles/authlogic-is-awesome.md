Probably every Rails developer has used <a href="http://github.com/technoweenie/restful-authentication" target="_blank">restful_authentication</a>. Most of us on practically every application. But restful_authentication generates quite some code and is somewhat an odd plugin. It is a bit out of place in the regular restful controllers that you make. They are making a new <a href="http://github.com/technoweenie/restful-authentication/tree/modular" target="_blank">modular version</a> of it, but it isn't much of an improvement, if you ask me.

Luckily, there is a new plugin/gem that does this better. It's called <a href="http://github.com/binarylogic/authlogic" target="_blank">AuthLogic</a>. It used to be called AuthGasm, but now we can actually install it without blushing every time we do <tt>ls vendor/plugins</tt>. It gives you a familiar <tt>acts_as_authentic</tt> for your user model (nothing more, mind you!) and a UserSession model, which isn't inheriting from ActiveRecord, but from AuthLogic::Session::Base class, which AuthLogic provides.
<!--more-->
The big plus is that now you can use <tt>form_for</tt> for user sessions just as you would for any ActiveRecord model. Your UserSessionsController can even be like rails scaffold provides. Just save to the @user_session object and a session is set.

You're free to make multiple sessions per user to be able to log in on multiple locations. Just read the <a href="http://github.com/binarylogic/authlogic/tree/master/README.rdoc" target="_blank">README</a> to see what is possible!

There are no specs provided with AuthLogic, so here are some helpers to spec controllers. Add them to spec_helper.rb or in another file which gets loaded by RSpec.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">current_user</font>(stubs = {})
&nbsp;&nbsp;<font color="#c6c5fe">@current_user</font>&nbsp;||= mock_model(<font color="#ffffb6">User</font>, stubs)
<font color="#96cbfe">end</font>

<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">user_session</font>(stubs = {}, user_stubs = {})
&nbsp;&nbsp;<font color="#c6c5fe">@current_user</font>&nbsp;||= mock_model(<font color="#ffffb6">UserSession</font>, {<font color="#99cc99">:user</font>&nbsp;=&gt; current_user(user_stubs)}.merge(stubs))
<font color="#96cbfe">end</font>

<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">login</font>(session_stubs = {}, user_stubs = {})
&nbsp;&nbsp;<font color="#ffffb6">UserSession</font>.stub!(<font color="#99cc99">:find</font>).and_return(user_session(session_stubs, user_stubs))
<font color="#96cbfe">end</font>

<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">logout</font>
&nbsp;&nbsp;<font color="#c6c5fe">@user_session</font>&nbsp;= <font color="#99cc99">nil</font>
<font color="#96cbfe">end</font></pre>

So you can write specs like this:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">describe <font color="#ffffb6">SecretsController</font>&nbsp;<font color="#6699cc">do</font>
&nbsp;&nbsp;before { login }
&nbsp;&nbsp;it <font color="#336633">&quot;</font><font color="#a8ff60">should be very very secret!</font><font color="#336633">&quot;</font>
<font color="#6699cc">end</font></pre>

And as a litte bonus, it works nice with my plugin: <a href="http://iain.nl/2008/09/acts_as_translatable_model-plugin/">acts_as_translatable_model</a>. Making your login forms is easier than ever! So please take a look at it! I'm betting you'll love it!