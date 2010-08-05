package Madrone::NamedNode;

use base Madrone::GenericNode;

# named "chunks" of template that can be used in other templates

use strict;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new();

	$self->{type} = "named";
	$self->{name} = '';

	bless($self,$class);
	return $self;
}

sub setName {
	my $self = shift;
	my $name = shift;

	$self->{name} = $name;
}

1;
