There is a real annoying gotcha in using controller tests to test an action that renders a pdf with [Prawn](http://prawn.majesticseacreature.com/). You'll get a NoMethodException on "nil.downcase". The troubling part is that it totally puts you off by providing the wrong lines and backtrace.

This has been mentioned somewhere on some [mailinglists](http://groups.google.com/group/prawn-ruby/browse_thread/thread/a44c7647894d165c), but to make it a bit more findable, I'd thought I'd post it here.

The <del>solution</del> workaround is to set the server protocol, like this:

    it "should show the pdf" do
      request.env["SERVER_PROTOCOL"] = "http"
      get :show, :id => "report", "format" => "pdf"
      response.should render_template(:show)
    end
