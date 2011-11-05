[Railscast episode 132](http://railscasts.com/episodes/132-helpers-outside-views) talks about using
helpers outside views. All in all a good and useful screencast. I only have one comment: In Rails
2.2 internationalized pluralization goes like this:

``` ruby
I18n.t(:people, :count => @people.size)
```

With these translation-files:

``` yaml
en:
  people:
    one: "one person"
    other: "%{count} people"
```

``` yaml
nl:
  people:
    one: "een persoon"
    other: "%{count} personen"
```
