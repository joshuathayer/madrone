package AWP::ClassNode;

use base AWP::GenericNode;
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
    $context->{nodeseq} = $self->{seq}; # XXX COPY COPY COPY
	$context->{node} = $self;

	# we need to run the function.
	my $sub = $self->{'sub'};
	$self->{instance}->$sub($context, $bindings, $cb);
}

1;
