If you've ever worked extensively with I18n in a Rails project, you know that the organisation of
your locale files is hard. Much like CSS files, locale files can grow large and become cluttered
within weeks. And as they grow, the likelyhood of merge conflicts increases and resolving them
becomes harder. Keeping your locale files short and tidy is important.

### The goal

Let me start by trying to define what we want from our locale files. This way, you can judge by
yourself if you organized your translations well enough.

We want to have less mental overhead when managing large sets of translations. The best way to test
this is to get someone outside your team to find a translation. Show him a phrase on the website
and tell him to change it. Is he able to find the translation quickly? Or does he have to rely on a
search tool?

The more intuitive your system is, the easier it becomes to manage and change it.

### Agree on a system

You should want everyone in the team to agree on the same structure. There is going to be some logic
to the way you organize your translations, so make sure everyone understands this logic and adheres
to it.

If you're going to restructure the translations, inform the others before pushing your changes. Due
to their indentation, merge conflicts in yaml-files can be hard to resolve, and you don't want to
surprise your colleagues with large conflicts.

### Use scopes

Just like in programming, [namespaces are one honking great
idea](http://www.python.org/dev/peps/pep-0020/). You should probably do more of those. This also
applies for translation keys.

This means, rather than doing:

``` ruby
I18n.t :name
```

You should do something like:

``` ruby
I18n.t :name, :scope => "projects"
```

Or specify the scope in the translation key:

``` ruby
I18n.t "projects.name"
```

This is to prevent name clashes, and to provide structure in your locale files.

### Split on feature

It's common to see locale files splitted on scope. This means that all the ActiveRecord translations
go into `activerecord.yml` and view translations of `projects/index.html.erb` (if you use `<%=
t('.foo') %>`) go into `projects.yml`. This is *not* the way to go.

You should split files up by feature. This means that `projects.yml` contains both the ActiveRecord
translations for the Project-model and the view translations, flash messages and so on. This makes
it easier to find translations. Your thought process could go along the lines of: "I am working on
something related to projects, so my translations need to go into `projects.yml`."

It also helps refactoring. If you need to change a word in your translations, you should only have
to look in one file. If the customer thinks that the "project manager" should now be called the
"project administrator", you can find the ActiveRecord translation, as well as flash messages and
the view translations on this subject nicely grouped together.

I18n will deeply merge the translations of different files. If you would define the same scope in
one file, the latter will override the former, but if they are in different files, the translations
will be woven together.

However, defining the exact same scope twice, will make one disappear, so make sure you create
a structure in which this won't happen easily. If two files are equally likely to contain the
translations, you might be tempted to choose the wrong one and end up defining the translation
twice.


### Consider using subdirectories

Directories are used to group files. That shouldn't be news to you. Feel free to use subdirectories
in the `config/locales` directory to structure your files even further.

Als consider transposing your directory structure. If your current structure is like this:

    config/locales
    ├── en
    │   ├── foo.yml
    │   └── bar.yml
    └── nl
        ├── foo.yml
        └── bar.yml

Try changing it to:

    config/locales
    ├── foo
    │   ├── nl.yml
    │   └── en.yml
    └── bar
        ├── nl.yml
        └── en.yml



This might make your application more modular. You could add or remove the "foo"-feature more
easily.

Don't overdo it though. If your directory structure isn't clear, it can let you search for many
minutes to find the translation you're looking for. Fragmentation is as bad as big files. If you
have to resort to tools like `grep`, `ack` or `rak`, you've definitely overdone it.

### Use namespacing

Using namespacing is a solution to many problems and you should probably do more of it. In this
case, you can define I18n in a namespace to add scopes automatically.

The main reason to scope your translations is because, even though translations in different files
will be deeply merged, when the scope is exactly identical, the last file to be loaded wins. So try
to avoid translations without any scope.

For instance, you could write something like:

``` ruby
module Projects::I18n
  def self.t(key, options = {})
    new_scope = [:projects] + Array(options[:scope])
    ::I18n.t(key, options.merge(:scope => new_scope))
  end
end
```

Whenver you call `I18n.t()` from inside the Projects namespace, it will put all translations the
projects scope. But you will have to really be inside that namespace for it to work. The next
example will work:

``` ruby
module Projects
  class StatusesController < ApplicationController
    def show
      flash[:notice] = I18n.t(:show_notice)
    end
  end
end
```

But the next example won't work, because you're not really *in* the namespace:

``` ruby
class Projects::StatusesController < ApplicationController
  def show
    flash[:notice] = I18n.t(:show_notice)
  end
end
```

You might also want to delegate `I18n.l()`, for translating dates, and make aliases for the long
names `I18n.translate()` and `I18n.localize()`.


### Use presenters

If you prepend your keys with a dot in a view, it will automatically scope to the location of the
view. So if the `projects/index.html.erb` contains:

``` erb
<%= t('.title') %>
```

It will be looked up within the `projects.index.title` scope.

This is very handy. You can divide views into multiple partials, each with their own title, intro
and body, and your locale file will be nicely structured, like this:

``` yaml
en:
  projects:
    index:
      title: All projects
    search:
      title: Find me some projects
```

But this approach does have its downsides. If you have identical texts in different views, you'll
have to either publicate the translation in your locale files, specify the complete scope in at
least one of the views or, do some linking in your locale files.

Another approach is to use a presenter (e.g. Draper) and define a translate function on that. You
can prepend a scope just like I've shown earlier.

The goal is to keep the distance of the translations similar to the distance they have in the
result. So if you have a title and a subtitle translation and they are shown next to each other in
the view, they should be next to eachother in the locale file.


Linking in locale files is done like this:

``` yaml
foo: &some_name
  bar: baz

bang:
  <<: *some_name
```

Now `bang.bar` will also result in "baz". It is a useful technique in small files, like in
`config/database.yml`, but in bigger locale files, it will become a mess.


### Finding big files

A file that is changed a lot, is a file you need to pay extra attention to. If a part of your code
base changes often, you have a higher risk of breaking things.

You can use the gem `churn` to find these files. It's worth checking out how often your locale files
change. If you've changed a locale file many times, it might contain to much translations.

Compare the churn on the locale file to the churn of the code that use this locale file. A large
difference indicates too many responsibilities.

Another possibility is to count the lines of your locales:

``` bash
for f in config/locales/**/*.yml; do echo "$(cat $f | wc -l) $f"; done
```

Smaller features probably have less translations than larger features, so if you see files that are
bigger than you'd expect, they are probably too big.
