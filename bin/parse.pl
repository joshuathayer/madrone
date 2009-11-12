use lib ('/Users/joshua/projects/awp/lib');

use strict;

use Data::Dumper;
use AWP::Parser;

my $p = AWP::Parser->new();
$p->includeMods("/Users/joshua/projects/awp/bin/subs");
$p -> parsefile("test.xml");
my $out = $p -> walk();
print $out;

