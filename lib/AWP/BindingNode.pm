package AWP::BindingNode;

use base AWP::GenericNode;

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
	my ($self, $context, $bindings, $cb) = @_;

	# 20091201, decided bindings need not to be in the context, since
	# that's clobberable. a local var makes more sense. perhaps we could 
	# do something like "look in the context if the local var doesn't have
	# the binding... but for now.
	#my $v = $context->{bindings}->{$self->{obj}}->{$self->{var}};
	my $v = $bindings->{$self->{obj}}->{$self->{var}};

	$cb->($v);
}

1;
