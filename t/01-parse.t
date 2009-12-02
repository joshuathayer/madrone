#!perl -T

use Test::More tests => 4;
use Data::Dumper;
use AWP::Parser;

my $p = AWP::Parser->new();
ok ( $p, 	"instantiate OK");
ok ( $p->includeMods("t/subs"), "include mods" );
ok ( $p -> parsefile("t/test.xhtml"), "parse file" );
my $out = $p -> walk();
ok ($out, "parsed OK");

