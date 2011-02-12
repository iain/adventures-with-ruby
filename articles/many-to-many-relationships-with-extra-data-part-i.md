Everybody probably read about has_many :through relations. With one simple command you can do some amazing stuff. Consider the following:
<pre lang="rails">
class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :newsletters, :through => :subscriptions
end

class Subscription < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :newsletter, :dependent => :destroy
end

class Newsletter < ActiveRecord::Base
  has_many :subscriptions
  has_many :users, :through => :subscriptions
  has_many :old_users, :through => :subscription, :conditions => 'age > 60'
end</pre>
Now you'll see that having a nice name for the join model is important for keeping it readable. From personal experience I really need to repeat that: <strong>It is important to give a good name to your join model.</strong> You might be tempted to use the default way of calling has_and_belongs_to_many. That would be newsletter_users. It would be incredibly annoying to have to refer to that name all the time, confusing and ugly.

Anyway, with this in place you can do nice stuff like: <tt>current_user.newsletters</tt> or <tt>@my_mag.old_users</tt>. It's cool, but still very elementary. And though you can do much more than this, there are still some loose ends. Sometimes you'll want to have the subscription, because you'll want to update it, or destroy it, or whatever. Here is one of many solutions:
<pre lang="rails">
class Newsletter < ActiveRecord::Base

  # amongst all the other stuff

  # find the subscription, call it like this:
  #   @newsletter.subscription_by(current_user).created_at
  def subscription_by(user)
    self.subscriptions.find_by_user_id(user.id)
  end

  # Creates a new subscription or updates the one already there, with the given attributes
  def save_subscription_for(user, attributes = {})
    s = self.subscription_by(user) || self.subscriptions.new(:user => user)
    s.update_attributes(attributes)
  end

end</pre>
There is more and more elegant ways to do this. I'll get back to you on that. Leave any suggestions in the comments.
