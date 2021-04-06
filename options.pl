#!/home/ben/software/install/bin/perl
use Z;
my @options = read_table ("$Bin/options.txt");
# The options are all lower case so no case-folding needs to be done.
@options = sort {$a->{name} cmp $b->{name}} @options;
my $pod = '';
my $test =<<'EOF';
use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use Test::More;
my $builder = Test::More->builder;
binmode $builder->output, ":encoding(utf8)";
binmode $builder->failure_output, ":encoding(utf8)";
binmode $builder->todo_output, ":encoding(utf8)";
binmode STDOUT, ":encoding(utf8)";
binmode STDERR, ":encoding(utf8)";
use HTML::Make::Page 'make_page';

my $warnings;
$SIG{__WARN__} = sub {
    $warnings = "@_";
};

EOF
for (@options) {
    my $name = $_->{name};
    $pod .= <<EOF;
=item $name

$_->{desc}

EOF
    my $example;
    if ($name ne 'style') {
	$example = "    my (\$h, \$b) = make_page ($name => $_->{example});\n";
    }
    else {
	$example = <<EOF;
    my \$$name = $_->{example}
    my (\$h, \$b) = make_page ($name => \$$name);
EOF
    }
    $test .=<<EOF;
eval {
$example
};
ok (! \$\@, "No errors");
if (\$\@) {
    diag (\$\@);
}
ok (\$warnings !~ /Unknown option/, "Option $name recognised");
EOF
    $pod .= "\n$example\n";
}
$test .=<<'EOF';
done_testing ();
EOF
write_ro ("$Bin/options.pod", $pod);
write_ro ("$Bin/t/options.t", $test);
exit;

sub write_ro ($podfile, $pod)
{
    if (-f $podfile) {
	chmod 0644, $podfile or die $!;
    }
    write_text ($podfile, $pod);
    chmod 0444, $podfile or die $!;
}
