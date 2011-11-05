A problem I keep running in to, especially with Haml, is how to render Ajax requests. Say you have
a partial on your page which is something dynamic, like a feedback form. Here you might want to
replace this partial with an updated version of that same partial. When making an ajax request,
you specify the id of the element you wish to update. But when the element is created inside the
partial, it gets rendered double.

``` haml
#feedback
  = remote_form_for(@feedback ||= Feedback.new, :url => @feedback, :update => 'feedback') do |f|
    = f.input_field :message
    = submit_tag
```

will result after the button is pressed:

``` html
<div id="feedback">
  <div id="feedback">
    <form>etc
  </div>
</div>
```

One solution is to create the div outside of the partial, but that would make the partial less self
sufficient. Since I am a big fan of self sufficient partials, I'd want to just render the partial,
and never to care about any div's around it.

An **ugly** solution, especially when using Haml, is to dynamically create the open and close tags:

``` haml
= '<div id="feedback">' unless request.xhr?
- remote_form_for(etc)
= '</div>' unless request.xhr?
```

My solution is a small helper, resulting in this view-code:

``` haml
= content_for_ajax_request(:id => 'feedback') do
  = remote_form_for(etc)
```

Which requires this helper:

``` ruby
def content_for_ajax_request(options = {}, &block)
  c = capture_haml { yield }
  request.xhr? ? c : content_tag(:div, c, options)
end
```

The only minor problem is, that it screws up the indentation, but I'm not being picky this time.

When you're not using Haml, but ERB, just use this:

``` ruby
def content_for_ajax_request(options = {}, &block)
  c = capture { yield }
  request.xhr? ? c : content_tag(:div, c, options)
end
```

Naturally, you can change the condition, if you'd like.

``` ruby
def div_if(condition, options = {}, &block)
  c = capture { yield }
  condition ? c : content_tag(:div, c, options)
end
```

This is exactly why I like Ruby so much. Using blocks can make your code so much sweeter...
