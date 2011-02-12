I released an old Rails plugin as gem today. Slowly but surely, all my plugins will be converted to gems.

This time it's an old one: [http_accept_language](http://github.com/iain/http_accept_language)

* Splits the http-header into languages specified by the user
* Returns empty array if header is illformed.
* Corrects case to xx-XX
* Sorted by priority given, as much as possible.
* Gives you the most important language
* Gives compatible languages

For more information, read the README on GitHub.
