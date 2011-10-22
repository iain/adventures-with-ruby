Probably every Rails developer has used
[restful_authentication](http://github.com/technoweenie/restful-authentication). Most of us on
practically every application. But restful_authentication generates quite some code and is somewhat
an odd plugin. It is a bit out of place in the regular restful controllers that you make. They are
making a new [modular version](http://github.com/technoweenie/restful-authentication/tree/modular)
of it, but it isn't much of an improvement, if you ask me.

Luckily, there is a new plugin/gem that does this better. It's called
[AuthLogic](http://github.com/binarylogic/authlogic). It used to be called AuthGasm, but now we
can actually install it without blushing every time we do `ls vendor/plugins`. It gives you a
familiar `acts_as_authentic` for your user model (nothing more, mind you!) and a UserSession model,
which isn't inheriting from ActiveRecord, but from AuthLogic::Session::Base class, which AuthLogic
provides.

The big plus is that now you can use `form_for` for user sessions just as you would for any
ActiveRecord model. Your UserSessionsController can even be like rails scaffold provides. Just save
to the @user_session object and a session is set.

You're free to make multiple sessions per user to be able to log in on multiple locations. Just
read the [README](http://github.com/binarylogic/authlogic/tree/master/README.rdoc) to see what is
possible!

There are no specs provided with AuthLogic, so here are some helpers to spec controllers. Add them
to spec_helper.rb or in another file which gets loaded by RSpec.

``` ruby
def current_user(stubs = {})
  @current_user ||= mock_model(User, stubs)
end

def user_session(stubs = {}, user_stubs = {})
  @current_user ||= mock_model(UserSession, {:user => current_user(user_stubs)}.merge(stubs))
end

def login(session_stubs = {}, user_stubs = {})
  UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
end

def logout
  @user_session = nil
end
```


So you can write specs like this:

``` ruby
describe SecretsController do
  before { login }
  it "should be very very secret!"
end
```

And as a litte bonus, it works nice with my plugin:
[acts_as_translatable_model](/acts_as_translatable_model-plugin). Making your login forms is easier
than ever! So please take a look at it! I'm betting you'll love it!
