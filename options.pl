#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use File::Slurper 'write_text';
use Table::Readable 'read_table';
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
write_text ("$Bin/options.pod", $pod);
write_text ("$Bin/t/options.t", $test);
