package AWP;

use strict;
use Data::Dumper;

=head1 NAME

AWP - An XHTML-based templating system.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

sub parseDirectory {
	my $templateDir = shift;
	my $modDir = shift;
	my $namednodes = shift;

	my $ret = {};

	opendir(TDIR, "$templateDir/");
	my @templates = readdir(TDIR);
	closedir(TDIR);

	foreach my $template (@templates) {

		my ($tname) = $template =~ /(.*)\.xhtml/;		
		next unless $tname;

    	my $p = AWP::Parser->new();
    	$p->setNamedNodes($namednodes);
    	$p->includeMods($modDir);
    	$p->parsefile("$templateDir/$template");
    	$ret->{$tname} = $p;
	}

	return $ret;

}


=head1 SYNOPSIS

	AWP is a lot like the Lift framework in scala.

1;
