package Madrone::GenericNode;

use strict;
use Data::Dumper;
use Madrone::NodeSeq;

sub new {
	my $class = shift;

	my $self = {};

    $self->{seq} = new Madrone::NodeSeq;
	$self->{out} = [];

	$self->{type} = "generic";

	bless($self, $class);
	return $self;
}

sub reset {
	my $self= shift;
	$self->{out} = [];
}

# the only node that will ever call this is the root node.
# first and last are not used until i can figure out when/why 
# they might be. jt 1/2011
sub walk {
	my ($self, $context, $bindings, $cb, $first, $last) = @_;

	# make tests stop complainig
	$first = $first ? $first : '';
	$last = $last ? $last : '';

    my $ns = $self->{seq};
    $ns->walk_all_nodes($context, $bindings, $cb);

#	my $on = 0;
#    my $seen = $self->{seq}->length;
#    my @out;
#
#    # this is duplicated in NodeSeq::WalkAllNodes. please unify this.
#    my $ni = $self->{seq}->iterator; 
#    while (my $n = $ni->next()) {
#
#        # this can probably go outside the while
#        my $ns = $context->{nodeseq};
#
#		my $onn = $on;	# need a new lexically-scoped var for the closure
#		$n->walk($context, $ns, $bindings, sub {
#			my $dat = shift;
#			$dat = $dat ? $dat : '';
#			$out[$onn] = $dat;
#			if (--$seen == 0) {
#				$cb->( join('', $first, @out, $last) );
#			}
#		});
#
#		$on++;
#	}
#### 

}

sub walk_no {
	my ($self, $context, $ns, $bindings, $cb) = @_;
	$self->walk_and_collect($context, $ns, $bindings, $cb);
}
1;
