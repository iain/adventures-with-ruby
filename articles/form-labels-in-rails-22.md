Shamelessly copy-pasted from the README file of the new plugin I released today:

Since form labels don’t use I18n in Rails 2.2 (I was too late in submitting the patch), we’d have to make due with a plugin.

Installation and configuration consists of 1 easy steps:

* Run: `./script/plugin install git://github.com/iain/i18n_label.git`

### Example

In your translation file:

    en-US:
      activerecord:
        attributes:
          topic:
            name: 'A nice name'

In your view:

    <% form_for Topic.new do |f| %>
      <%= f.label :name %>
    <% end %>

The result is:

    <label for="topic_name">A nice name</label>

For more information about where to put your translations, read my post about [translating ActiveRecord](/translating-activerecord/).
