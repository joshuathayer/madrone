package AWP::ClassNode;

use base AWP::GenericNode;

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
	my $instance = new $mod;

	$self->{func} = $func;
	$self->{mod} = $mod;
	$self->{'sub'} = $sub;
	$self->{instance} = $instance;
}

sub walk {
	my ($self, $context, $cb) = @_;

	$context->{nodeseq} = $self->{nodes}; 
	$context->{node} = $self;

	# we need to run the function.

	my $sub = $self->{'sub'};
	$self->{instance}->$sub($context, $cb);
}
		


1;
