I released an old Rails plugin as gem today. Slowly but surely, all my plugins will be converted to gems.

This time it's an old one: <a href="http://github.com/iain/http_accept_language">http_accept_language</a>

<ul>
<li>Splits the http-header into languages specified by the user</li>
<li>Returns empty array if header is illformed.</li>
<li>Corrects case to xx-XX</li>
<li>Sorted by priority given, as much as possible.</li>
<li>Gives you the most important language</li>
<li>Gives compatible languages</li>
</ul>

For more information, read the README on GitHub.
