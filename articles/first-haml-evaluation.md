As I <a title="my original announcement" href="/the-knights-templater-part-ii-priory-of-haml">promised</a>, here is the evaluation of redoing a site from ERB to <a title="Haml homepage" href="http://haml.hamptoncatlin.com/" target="_blank">Haml</a>. To immediately cut to the chase: Haml IS worth it!
<ol>
  <li>It's so definitely faster and easier to write than ERB.</li>
  <li>Your HTML output is nicer.</li>
  <li>Partials rendering with the right indentation automatically.</li>
  <li>It forces you to take a good look of what you're actually making.</li>
  <li>Because it's so strict on it's syntax, you will be using more helpers and custom model methods, which is a good thing.</li>
  <li>No more forgetting to close a div and spending hours to find out which one.</li>
  <li>Faster refactoring because of less code and easier to read.</li>
</ol>
There are some downsides however. I'd rather not talk about the hours I tried to fix some idiot problem with partials and the locals option. Just use locals as less as possible, preferably not at all. <!--more-->Some cons:
<ol>
  <li>Yet another syntax to be learned.</li>
  <li>Errors with Haml syntax are a bit harder to locate, but you'll make less after you encountered a few.</li>
  <li>A gem needs to be installed on the server, which can be difficult if you don't have root rights on the server</li>
  <li>The syntax highlighter on VIm is not quite up to it.</li>
  <li>Rails helpers screw up the nice HTML Haml creates for you. The form_tag helpers for example.</li>
</ol>
So if you are starting a new project, or redoing the entire HTML of you're application: try Haml! Chances are you'll like it!
