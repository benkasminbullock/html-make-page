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
for (@options) {
    $pod .= <<EOF;
=item $_->{name}

$_->{desc}

EOF
}
write_text ("$Bin/options.pod", $pod);
