#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'AWP' );
	use_ok( 'AWP::Parser' );
}

diag( "Testing AWP $AWP::VERSION, Perl $], $^X" );
