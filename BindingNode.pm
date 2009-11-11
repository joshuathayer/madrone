package BindingNode;

use base GenericNode;

use strict;

sub new {
	my $class = shift;

	my $self = $class->SUPER::new();

	$self->{type} = "bind";

	bless($self, $class);
	return $self;
}

sub setBindObject{
	my ($self, $obj) = @_;
	$self->{obj} = $obj;
}

sub setBindVar {
	my ($self, $var) = @_;
	$self->{var} = $var;
}

sub walk {
	my $self = shift;
	my $context = shift;

	my $v = $context->{bindings}->{$self->{obj}}->{$self->{var}};

	return $v;
}

1;
