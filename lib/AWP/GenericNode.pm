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

# you can give me scalars to stick and beginning and end of my return scalar
sub walk_and_collect {
	my ($self, $context, $bindings, $cb, $first, $last) = @_;

	# make tests stop complainig
	$first = $first ? $first : '';
	$last = $last ? $last : '';

	my $on = 0; my $seen = scalar(@{$self->{nodes}}); my @out;

	foreach my $n (@{$self->{nodes}}) {
		$n->walk($context, $bindings, sub {
			my $dat = shift;
			$dat = $dat ? $dat : '';
			$out[$on] = $dat;
			$on += 1;
			$seen -= 1;

			if ($seen == 0) {
				$cb->( join('', $first, @out, $last) );
			}
		});
	}

}

sub walk {
	my ($self, $context, $bindings, $cb) = @_;
	$self->walk_and_collect($context, $bindings, $cb);
}
1;
