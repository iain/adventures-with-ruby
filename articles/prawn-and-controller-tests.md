<img src="http://iain.nl/wp-content/uploads/2009/11/prawn_logo-150x150.png" alt="prawn_logo" title="prawn_logo" width="150" height="150" class="alignright size-thumbnail wp-image-563" />There is a real annoying gotcha in using controller tests to test an action that renders a pdf with <a href="http://prawn.majesticseacreature.com/">Prawn</a>. You'll get a NoMethodException on "nil.downcase". The troubling part is that it totally puts you off by providing the wrong lines and backtrace.

This has been mentioned somewhere on some <a href="http://groups.google.com/group/prawn-ruby/browse_thread/thread/a44c7647894d165c">mailinglists</a>, but to make it a bit more findable, I'd thought I'd post it here.

The <s>solution</s>workaround is to set the server protocol, like this:

[sourcecode language=ruby]
    it "should show the pdf" do
      request.env["SERVER_PROTOCOL"] = "http"
      get :show, :id => "report", "format" => "pdf"
      response.should render_template(:show)
    end
[/sourcecode]

