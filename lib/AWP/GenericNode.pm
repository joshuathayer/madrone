package AWP::GenericNode;

use strict;
use Data::Dumper;
use AWP::NodeSeq;

sub new {
	my $class = shift;

	my $self = {};

    $self->{seq} = new AWP::NodeSeq;
	$self->{out} = [];

	$self->{type} = "generic";

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

	my $on = 0;
    my $seen = $self->{seq}->length;
    my @out;

# PUT THIS IN NODESEQ
    my $ni = $self->{seq}->iterator; 
    while (my $n = $ni->next()) {
		my $onn = $on;	# need a new lexically-scoped var for the closure
		$n->walk($context, $bindings, sub {
			my $dat = shift;
			$dat = $dat ? $dat : '';
			$out[$onn] = $dat;
			if (--$seen == 0) {
				$cb->( join('', $first, @out, $last) );
			}
		});

		$on++;
	}
#### 

}

sub walk {
	my ($self, $context, $bindings, $cb) = @_;
	$self->walk_and_collect($context, $bindings, $cb);
}
1;
