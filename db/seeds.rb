page_text = <<-EOF
<p>
  Hi!&nbsp;Welcome to <i>Wikenso!</i>
</p>

<p><br></p>

<p>
Here's what you can do to <b>get</b> <b>started</b>.</p><p><br>
</p>

<p>- <a href=\"http://myfirstwiki.wikenso.dev/settings\">Give</a> your wiki a name and a logo</p>
<p>- <a href=\"http://myfirstwiki.wikenso.dev/users\">Invite</a> more users to this wiki<br></p>
<p>- You can also try <a href=\"http://myfirstwiki.wikenso.dev/pages/myfirstwiki-welcome/edit\">editing</a> this page or <a href=\"http://myfirstwiki.wikenso.dev/pages/new\">creating</a> a new page.</p>
<p><br></p>

<p>Let us know if you need any help!</p>
EOF

WelcomePage.create(title: "Welcome!", text: page_text)
