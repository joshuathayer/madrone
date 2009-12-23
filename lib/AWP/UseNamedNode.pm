package AWP::UseNamedNode;

use base AWP::GenericNode;
use Data::Dumper;

# named "chunks" of template that can be used in other templates

use strict;

sub new {
	my $class = shift;
	my $namednodes = shift;

	my $self = $class->SUPER::new();

	$self->{type} = "usenamed";
	$self->{name} = '';
	$self->{namednodes} = $namednodes;

	bless($self,$class);
	return $self;
}

sub setName {
	my $self = shift;
	my $name = shift;

	$self->{name} = $name;
}

sub walk_and_collect {
	my ($self, $context, $bindings, $cb, $first, $last) = @_;

	$first = $first ? $first : '';
	$last = $last ? $last : '';

	#print "UseNamedNode walk_and_collect, bindings:\n";
	#print Dumper $bindings;

	my $nodes = $self->{namednodes}->{ $self->{name} }->{nodes};
	unless (scalar($nodes)) { $cb->(); }

	#print "i have " . scalar(@$nodes) . " nodes to walk in UseNamedNode, name $self->{name}\n";

	my $on = 0; my $seen = scalar(@{$nodes}); my @out;

	foreach my $n (@$nodes) {
		my $onn = $on;

		$n->walk($context, $bindings, sub {
			my $dat = shift;
			$dat = $dat ? $dat : '';
			$out[$onn] = $dat;
			if (--$seen == 0) {
				$cb->(join('',$first, @out, $last));
			}
		});
		$on++;
	}
}

sub walk {
	my ($self, $context, $bindings, $cb) = @_;
	$self->walk_and_collect($context, $bindings, $cb);
}

1;
