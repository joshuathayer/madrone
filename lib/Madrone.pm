package Madrone;

use strict;
use Data::Dumper;

=head1 NAME

Madrone - An XHTML-based templating system.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

sub parseDirectory {
	my ($templateDir, $modDir, $namednodes) = @_;

    print "hello $templateDir $modDir\n";

    $namednodes = {} unless defined ($namednodes);

	my $ret = {};

	opendir(TDIR, "$templateDir/");
	my @templates = readdir(TDIR);
	closedir(TDIR);

	foreach my $template (@templates) {

		my ($tname) = $template =~ /(.*)\.xhtml$/;
		next unless $tname;

    	my $p = Madrone::Parser->new(Style => 'Debug');
    	$p->setNamedNodes($namednodes);
    	$p->includeMods($modDir);
    	$p->parsefile("$templateDir/$template");
    	$ret->{$tname} = $p;
	}

	return $ret;

}


=head1 SYNOPSIS

	Madrone is a lot like the Lift framework in scala.

1;
