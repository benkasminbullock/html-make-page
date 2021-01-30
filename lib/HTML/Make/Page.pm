package HTML::Make::Page;
use warnings;
use strict;
use Carp;
use utf8;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw/make_page/;
our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
);
our $VERSION = '0.00_01';
use HTML::Make '0.15';

sub make_page
{
    my (%options) = @_;
    my $quiet;
    if ($options{quiet}) {
	$quiet = $options{quiet};
	delete $options{quiet};
    }
    my $html = HTML::Make->new ('html');
    if ($options{lang}) {
	delete $options{lang};
	$html->add_attr (lang => $options{lang});
    }
    my $head = $html->push ('head');
    $head->push (
	'meta',
	attr => {
	    charset => 'UTF-8'
	}
    );
    $head->push (
	'meta',
	attr => {
	    name => 'viewport',
	    content =>
	    'width=device-width, initial-scale=1.0'
	}
    );
    if ($options{css}) {
	for my $css (@{$options{css}}) {
	    $head->push (
		'link',
		attr => {
		    rel => 'stylesheet',
		    type => 'text/css',
		    href => $css,
		}
	    );
	}
	delete $options{css};
    }
    if ($options{title}) {
	$head->push ('title', text => $options{title});
	delete $options{title};
    }
    else {
	if (! $quiet) {
	    carp "No title";
	}
    }
    if ($options{style}) {
	$head->push ('style', text => $options{style});
	delete $options{style};
    }
    if (! $quiet) {
	for my $k (keys %options) {
	    carp "Unknown option $k";
	    delete $options{$k};
	}
    }
    my $body = $html->push ('body');
    return ($html, $body);
}

1;
