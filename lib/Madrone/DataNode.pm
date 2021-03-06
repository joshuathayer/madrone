package Madrone::DataNode;

use base Madrone::GenericNode;

use strict;

sub new {
	my $class = shift;

	my $self = $class->SUPER::new();

	$self->{type} = "data";

	bless($self, $class);

	return $self;
}

sub setData {
	my ($self, $data) = @_;

	$self->{data} = $data;
}

sub walk {
	my ($self, $context, $bindings, $cb) = @_;

	# we'll never have nodes of our own to walk
	# maybe we will want a special i18n node!
	
	$cb->($self->{data});
}

1;
