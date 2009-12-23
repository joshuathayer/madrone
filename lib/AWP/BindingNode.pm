package AWP::BindingNode;

use base AWP::GenericNode;
use Data::Dumper;

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

	#print "binding node $self->{obj} $self->{var}:\n";
	#print Dumper $bindings;

	my $v = $bindings->{$self->{obj}}->{$self->{var}};

	$cb->($v);
}

1;
