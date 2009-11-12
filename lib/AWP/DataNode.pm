package AWP::DataNode;

use base AWP::GenericNode;

use strict;

sub new {
	my $class = shift;

	my $self = $class->SUPER::new();
	print Dumper $self;

	$self->{type} = "data";

	bless($self, $class);

	return $self;
}

sub setData {
	my ($self, $data) = @_;

	$self->{data} = $data;
}

sub walk {
	my $self = shift;

	# we'll never have nodes of our own to walk
	# maybe we will want a special i18n node!
	
	return $self->{data};
}

1;
