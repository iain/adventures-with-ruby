Shamelessly copy-pasted from the README file of the new plugin I released today:

Since form labels don’t use I18n in Rails 2.2 (I was too late in submitting the patch), we’d have to make due with a plugin.

Installation and configuration consists of 1 easy steps:

<ol>
  <li>Run: <tt>./script/plugin install git://github.com/iain/i18n_label.git</tt></li>
</ol>

<h3>Example</h3>

In your translation file:

<pre lang="yaml">
en-US:
  activerecord:
    attributes:
      topic:
        name: 'A nice name'
</pre>

In your view:

<pre lang="rails">
<% form_for Topic.new do |f| %>
  <%= f.label :name %>
<% end %>
</pre>

The result is:

<pre>
&lt;label for="topic_name">A nice name&lt;/label>
</pre>

For more information about where to put your translations, read my post about <a href="/translating-activerecord/">translating ActiveRecord</a>.
