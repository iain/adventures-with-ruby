The old subject of nested forms comes back again to hunt me. Rails 2.3 has the new and shiny <tt>accepts_nested_attributes_for</tt> feature. I like it, but there are some things to take into consideration. Adding a child object through javascript remains a bitch to tackle. So I sat down and wrote some javascript. Here is what I came up with. Not sure if I'm going to release this a plugin though.

First of, build the models. I have a project with many stages:

[sourcecode language='ruby']
class Project < ActiveRecord::Base
  validates_presence_of :name
  has_many :stages
  accepts_nested_attributes_for :stages, :allow_destroy => true
end

class Stage < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :project
end
[/sourcecode]
<!--more-->
Here is what the form partial for the project looks like:

[sourcecode language='ruby']
- form_for @project do |form|
  %p
    = form.label :name
    = form.text_field :name
  #stages
    - form.fields_for :stages do |fields|
      = render :partial => "stage", :locals => { :form => fields }
  %p= partial_button(f, :stage, "Add stage")
[/sourcecode]

And the stage partial:

[sourcecode language='ruby']
.stage[form.object]
  %p
    = form.label :title
    = form.text_field :title
  %p= remove_partial(form, "Remove stage")
[/sourcecode]

Ok, so nothing to scary there. Nice clean views. Those two helper methods might be scary though. But apart from that, it's actually quite normal.

Notice that the square brackets used at the first line of the stage partial either adds a class "new_stage" or "stage_X" (where X is the id of an existing stage object).

Let's see what's inside the <tt>partial_button</tt> method!

<!--more-->

[sourcecode language='ruby']
def partial_button(form, attribute, link_name)
  returning "" do |out|
    base      = form.object.class.to_s.underscore
    singular  = attribute.to_s.underscore
    plural    = singular.pluralize
    id        = "add_nested_partial_#{base}_#{singular}"
    form.fields_for attribute.to_s.classify.constantize.new do |field|
      html = render(:partial => singular, :locals => { :form => field})
      js   = %|new NestedFormPartial("#{escape_javascript(html)}", { parent:"#{base}", singular:"#{singular}", plural:"#{plural}"}).insertHtml();|
      out << hidden_field_tag(nil, js, :id => "js_#{id}") + "\n"
      out << content_tag(:input, nil, :type => "button", :value => link_name, :class => "add_nested_partial", :id => id)
    end
  end
end
[/sourcecode]

Ok, this looks scary. But it isn't that scary. This method returns a string called <tt>out</tt>. First of I build some variables, which will be needed as options for the javascript, since javascript doesn't have those cool inflections ActiveSupport has.

Second, I am going to make a fields_for block, which you'll already know what it does. I render the partial and assign it to the <tt>html</tt> variable. Then I generate some javascript which initiates a new <tt>NestedFormPartial</tt> object. Finally, I build a hidden field, which contains this javascript as value and a button.

Here's the javascript, you'll need to add:

[sourcecode language='js']
var NestedFormPartial = Class.create();
NestedFormPartial.prototype = {
  initialize : function(html, options){
    this.newId          = "new_" + new Date().getTime();
    this.html           = html;
    this.parentName     = options["parent"];
    this.singularName   = options["singular"];
    this.pluralName     = options["plural"];
    if (!this.pluralName) this.pluralName = this.singularName + "s";
    this.replaceHtml();
  },
  oldPartialId : function(){
    return this.singularName + "_new";
  },
  oldElementId : function(){
    return this.parentName + "_" + this.singularName + "_";
  },
  oldElementName : function(){
    return this.parentName + "\\[" + this.singularName + "\\]";
  },
  newPartialId : function(){
    return this.singularName + "_" + this.newId;
  },
  newElementId : function(){
    return this.parentName + "_" + this.newPartialId() + "_";
  },
  newElementName : function(){
    return this.parentName + "[" + this.pluralName + "_attributes][" + this.newId + "]";
  },
  replaceFunction : function(pattern, replacement) {
    this.html = this.html.replace(new RegExp(pattern, "g"), replacement);
  },
  replaceHtml : function(){
    this.replaceFunction(this.oldPartialId(),   this.newPartialId());
    this.replaceFunction(this.oldElementId(),   this.newElementId());
    this.replaceFunction(this.oldElementName(), this.newElementName());
  },
  insertHtml : function(){
    $(this.pluralName).insert({ bottom :  this.html });
  },
}

function initPartialButtons() {
  $$(".add_nested_partial").each(function(button, index) {
    Event.observe(button, "click", function(evt) {
      eval($("js_" + button.id).value);
    })
  });
}

Event.observe(window, 'load', initPartialButtons, false);
[/sourcecode]

Ehm, what did I just do there? Well, the most important thing is that some parts of the partial get replaced. There are three problems which need to be addressed:

<ul><li>A new object always has the same generated id for input fields. Adding two stages would mean that their ids would be the same and that would mean that the labels wouldn't be clickable (and it wouldn't be valid html).</li>
<li>Rails wants "stages_attributes" to be included, when providing a new object, it would be named simple "stage".</li>
<li>Rails expects a hash as stages_attributes. We'll need to add some arbitrary key, so it'll turn into a hash.</li></ul>

I generate a new id by using the timestamp and replace the values in my html. When the window loads I find any add_nested_partial class button and eval the value of the hidden field I added earlier, so the scripts gets executed.

As you can see, I did my best to make this as unobtrusive as possible, but going any further made my head hurt.

Finally, the <tt>remove_partial</tt> method, which I haven't cleaned up yet:

[sourcecode language='ruby']
def remove_partial(form, link_name)
  attribute = form.object.class.name.underscore
  if form.object.new_record?
    button_to_function(link_name, "$(this).up('.#{attribute}').remove()")
  else
    form.hidden_field(:_delete) +
    button_to_function(link_name, "$(this).up('.#{attribute}').hide(); $(this).previous().value = '1'")
  end
end
[/sourcecode]

I hope this helps. I found a lot of my initial optimism after hearing about <tt>accepts_nested_attributes_for</tt> have gone now. It cleans up a lot of code in the model though. I'll keep this post updated when I have some improvements.

Sources:
<ul><li><a href="http://ryandaigle.com/articles/2009/2/1/what-s-new-in-edge-rails-nested-attributes" target="_blank">Ryan's Scraps</a></li>
<li><a href="http://github.com/alloy/complex-form-examples/tree/master" target="_blank">Eloy Duran's complex form examples</a></li></ul>