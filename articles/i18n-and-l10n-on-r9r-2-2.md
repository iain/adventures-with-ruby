**Updated at October 10th 2008 to be up to date with Rails 2.2 RC1**

Ruby on Rails (r9r ;) ) v2.2 ships with builtin internationalization (i18n). It tries to solve the problem dividing the world: language and localization (l10n). This topic is the most annoying of most topics in programming. Anyone who has ever worked with dates, timezones and number formatting has probably been swearing at it, loosing sleep over it and cursing the fact that difference exist between cultures. The idiot that made this decision *"I know that they use a comma as delimiter in country X, but in my country we're going to use a dot!"* certainly deserves to be shot, if he (or she) hasn't already died. And whoever thought of the ridiculous way in how we measure time? Dates and times really suck!

There are two kinds of problems here. If you live in a country other than the US, preferably one where they don't speak English, and want to make a website, you're immediately fucked. If you are from any English speaking country, or just don't care yet, the problem will arise a bit later when you're expanding beyond the borders.

Making your site in just 1 language is relatively easy. Before Rails 2.2 we had to rely on a lot of [monkeypatching](http://agilewebdevelopment.com/plugins/dutchify), overriding some key parts of the framework. But not anymore. In Rails 2.2, only two lines will fix the problem.

    I18n.locale = 'nl-NL'
    I18n.load_path << "#{RAILS_ROOT}/config/translations.yml"

Put them somewhere they'll get loaded, an [initializer](http://ryandaigle.com/articles/2007/2/23/what-s-new-in-edge-rails-stop-littering-your-evnrionment-rb-with-custom-initializations) will do. All you need to do now is to make you're basic Rails translations for you language. Does your language use a dot or a comma, what does "invalid" mean in your language, etc.

Having multiple translations at once, were the user can choose the language they prefer, is a bit more difficult. You have to find out which language they have chosen and load the proper translation file every time a new request comes in. The best way to do this is make a before_filter in your application controller. In here you find out what the language is, and load the appropriate file.

    class ApplicationController < ActionController::Base
      before_filter :set_locale
      private
      def set_locale
        I18n.locale = params[:locale] or session[:locale] or I18n.default_locale
      end
    end

How to make translation files is the topic of my next post, so stay tuned! Stay updated through the [mailinglist](http://groups.google.com/group/rails-i18n/) too! For now, things are still changing rapidly, so please take care. When Rails 2.2 ships (hopefully somewhere next month), it'll be safe!
