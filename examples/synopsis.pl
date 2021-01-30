#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use HTML::Make::Page 'make_page';
my ($html, $body) = make_page (title => 'Personal Home Page');
$body->add_text (<<EOF);
<img src='under-construction.gif' alt='This site is ALWAYS under construction!!!'>
<p>Include your tedious and embarrassing personal details here.</p>
EOF
print $html->text ();
