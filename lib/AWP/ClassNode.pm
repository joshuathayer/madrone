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
	my $self = shift;
	my $context = shift;

	$context->{nodeseq} = $self->{nodes};

	my $sub = $self->{'sub'};
	my $out = $self->{instance}->$sub($context);

	return $out;
}
		


1;
