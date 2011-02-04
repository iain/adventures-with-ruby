A problem I keep running in to, especially with Haml, is how to render Ajax requests. Say you have a partial on your page which is something dynamic, like a feedback form. Here you might want to replace this partial with an updated version of that same partial. When making an ajax request, you specify the id of the element you wish to update. But when the element is created inside the partial, it gets rendered double.<!--more-->

<pre lang="rails">
#feedback
  = remote_form_for(@feedback ||= Feedback.new, :url => @feedback, :update => 'feedback') do |f|
    = f.input_field :message
    = submit_tag
</pre>

will result after the button is pressed:

<pre lang="rails">
<div id="feedback">
  <div id="feedback">
    <form>etc
  </div>
</div>
</pre>

One solution is to create the div outside of the partial, but that would make the partial less self sufficient. Since I am a big fan of self sufficient partials, I'd want to just render the partial, and never to care about any div's around it.

An <strong>ugly</strong> solution, especially when using Haml, is to dynamically create the open and close tags:

<pre lang="rails">
= '<div id="feedback">' unless request.xhr?
- remote_form_for(etc)
= '</div>' unless request.xhr?
</pre>

My solution is a small helper, resulting in this view-code:

<pre lang="rails">
= content_for_ajax_request(:id => 'feedback') do
  = remote_form_for(etc)
</pre>

Which requires this helper:

<pre lang="rails">
def content_for_ajax_request(options = {}, &block)
  c = capture_haml { yield }
  request.xhr? ? c : content_tag(:div, c, options)
end
</pre>

The only minor problem is, that it screws up the indentation, but I'm not being picky this time.

When you're not using Haml, but ERB, just use this:

<pre lang="rails">
def content_for_ajax_request(options = {}, &block)
  c = capture { yield }
  request.xhr? ? c : content_tag(:div, c, options)
end
</pre>

Naturally, you can change the condition, if you'd like.

<pre lang="rails">
def div_if(condition, options = {}, &block)
  c = capture { yield }
  condition ? c : content_tag(:div, c, options)
end
</pre>

This is exactly why I like Ruby so much. Using blocks can make your code so much sweeter...