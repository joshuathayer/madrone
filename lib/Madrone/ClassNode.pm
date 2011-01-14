package Madrone::ClassNode;

use base Madrone::GenericNode;
use Data::Dumper;

use strict;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new();

	$self->{type} = "class";

	bless($self,$class);
	return $self;
}

sub setFunction {
	my $self = shift;
	my $func = shift;

	my ($mod, $sub) = $func =~ /(.*)\.(.*)/;
	my $instance = $mod->new();

	$self->{func} = $func;
	$self->{mod} = $mod;
	$self->{'sub'} = $sub;
	$self->{instance} = $instance;
}

sub walk {
	my ($self, $context, $bindings, $cb) = @_;

    # we want our user code to be able to operate
    # on a copy of our child tree. not on the original,
    # since modifying the original will mutate other user's 
    # tree walks
    my $ns = $self->{seq};
	$context->{node} = $self;

	# the method to call
	my $sub = $self->{'sub'};

	$self->{instance}->$sub($context, $ns, $bindings, $cb);
}

1;
