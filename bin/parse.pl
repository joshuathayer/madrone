use strict;

use AnyEvent;

use lib ("../lib/");

use Data::Dumper;
use Madrone::Parser;

my $p = Madrone::Parser->new();
$p -> includeMods("subs");
$p -> parsefile("test.xml");
print "parse done\n";

my $cv = AnyEvent->condvar;
my $context = {}; my $bindings = {};

$p -> walk($context, $bindings, sub {
	my $dat = shift;
	print "got: $dat\n";
	$cv->send;
});

$cv->recv;
