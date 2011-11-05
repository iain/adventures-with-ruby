Here is the next installment of a series of guides I'm writing for internationalizing a Rails 2.2
application. Please read the first part, [Translating ActiveRecord](/translating-activerecord), if
you haven't already. This time I'm going to talk about how to localize dates and times to a specific
language.

First a small recap in how to load locales. Add this to a new initializer:

``` ruby
I18n.load_path += Dir.glob("#{RAILS_ROOT}/app/locales/**/*.yml")
```

This has been changed at a very late moment. `I18n.store_translations` and `I18n.load_translations`
have been removed.

After that, you need to create a place to store your locales. Make the directory
`app/locales/nl-NL/` and place your yaml files in there. Here is the English version of the
locale-file:

``` yaml
en-US:
  date:
    formats:
      # Use the strftime parameters for formats.
      # When no format has been given, it uses default.
      # You can provide other formats here if you like!
      default: "%Y-%m-%d"
      short: "%b %d"
      long: "%B %d, %Y"

    day_names: [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]
    abbr_day_names: [Sun, Mon, Tue, Wed, Thu, Fri, Sat]

    # Don't forget the nil at the beginning; there's no such thing as a 0th month
    month_names: [~, January, February, March, April, May, June, July, August, September, October, November, December]
    abbr_month_names: [~, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]
    # Used in date_select and datime_select.
    order: [ :year, :month, :day ]

  time:
    formats:
      default: "%a, %d %b %Y %H:%M:%S %z"
      short: "%d %b %H:%M"
      long: "%B %d, %Y %H:%M"
    am: "am"
    pm: "pm"
```

All you need to do is replace the English terms with the translated versions. Remember that all
these keys are necessary to have. If you leave out, say month_names, it won't work at all.

After this is done, translate dates and times like this:

``` ruby
I18n.localize(Date.today)
```

If you want to use any of the other formats, specify this in the options hash:

``` ruby
I18n.localize(Date.today, :format => :short)
```

One more tip: you can add as many formats as you like, but remember that formats like
`:db` are reserved for obvious reasons. Here is an overview of the [strftime syntax in
Ruby](http://www.ruby-doc.org/core/classes/Time.html#M000297).

**PS.** Rails 2.2 RC1 is really really close now!
