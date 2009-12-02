package AWPTest;

use strict;
use Data::Dumper;


sub new {
	my $class = shift;

	my $self = {
		bindings => {},
	};

	bless $self, $class;
	return $self;
}

sub yes {
	my $self = shift;
	my $context = shift;

	my $nodeseq = $context->{nodeseq};
	#print Dumper $nodeseq;

	# simple demo sub. we pretend we test something in the state we're passed in,
	# and we just say "yes" and descend into our nodeseq. let's pretend that instead of
	# us actually exec'ing the nodeseq, we return it and allow the calling code to descend it
	#print "in AWPTest::yes!\n";
	#print Dumper $context;
	
	$context->{bindings}->{f}->{first_name} = "jerry";
	$context->{bindings}->{f}->{last_name} = "garcia";
	
	my @out;
	foreach my $n (@$nodeseq) {
		push (@out, $n->walk($context));
	}

	return(join('',@out));
}

sub rows {
	my $self = shift;
	my $context = shift;

	my $nodeseq = $context->{nodeseq};
	my $user = $context->{user};
	my $request = $context->{request};
	my $server = $context->{server};

	my @out;

	# let's say, 10 rows...
	foreach my $n (0 .. 10) {
		$context->{bindings}->{rows}->{id} = $n;
		foreach my $n (@$nodeseq) {
			push (@out, $n->walk($context));
		}
	}

	return(join('',@out));
}

sub no {
	my $self = shift;

	# don't descend into nodeseq

	return undef;
}

sub getBinding {
	my ($self, $o, $v) = @_;
	# print Dumper $self;
	
	my $r = $self->{bindings}->{$o}->{$v};
	# print "getBinding $o $v returning $r\n";

	return $r;
}

1;	
