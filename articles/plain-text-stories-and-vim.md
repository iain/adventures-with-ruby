<h3><font color="#ff6600"><strong>Update:</strong> Updated the syntax file, redownload it if you got it before December 19th 2007.</font></h3>
More news about my adventures with Selenium. It's hot and juicy, so lot's of exciting new things to do. I made a syntax highlighter for plain text stories in vim. Here's how it looks:

To make it look like this, I adjusted the slate colorscheme and added my own story syntax file. Click <a href="/plain-text-stories-and-vim/#more-31" title="Continue Reading">Continue Reading</a> to download the files and read how to install it.
<!--more--><h3>Here is what you need to do:</h3>
<ol>
  <li>Put the <a href="/black-slate.vim" title="My custom vim color scheme">black-slate colorscheme file</a> in /usr/share/vim/vim71/colors directory</li>
  <li>Put the <a href="/story.vim" title="story syntax file">story syntax file</a> in /usr/share/vim/vim71/syntax directory</li>
  <li>Append these lines to the end of /usr/share/vim/vim71/scripts.vim:
<pre>if did_filetype()
  finish
endif
if getline(1) =~ "^Story:\s.*"
  setf story
endif</pre></li>
  <li>Add these lines to your personal vimrc (~/.vimrc) or the systemwide vimrc file (/etc/vim/vimrc):
<pre>set background=dark
set tabstop=2   "please default all tabs to 2 spaces
set shiftwidth=2
set expandtab
set number
set smartindent
set smarttab
filetype plugin on
filetype indent on
colorscheme black-slate</pre></li>
  <li>Type your plain text stories, make sure every story file starts with 'Story:'
It won't recognize it's a plain text story right away, so first type 'Story:', save it and reopen it to get nice colours.</li>
</ol>
By the way, Arie has made a syntax highlighter for the google javascript syntax highlighter. Keep a look out on <a href="http://ariekanarie.nl/" title="Arie's Blog" target="_blank">his blog</a> too!

Caution: Wordpress changes the quotes. In step 3 you'll need normal quotes, not backticks.
