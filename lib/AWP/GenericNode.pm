package AWP::GenericNode;

use strict;
use Data::Dumper;

sub new {
	my $class = shift;

	my $self = {};

	$self->{nodes} = [];
	$self->{out} = [];

	bless($self, $class);
	return $self;
}

sub reset {
	my $self= shift;
	$self->{out} = [];
}

sub walk {
	my $self = shift;
	my $context = shift;

	# this foreach means we can't in-place modify our tree...
	foreach my $n (@{$self->{nodes}}) {
		#print Dumper $n;
		#print "-" x 30;
		#print "\n\n";
		push (@{$self->{out}}, $n->walk($context));
	}

	return join('',@{$self->{out}});
}


1;
