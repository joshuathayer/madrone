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
	my ($self, $context, $cb) = @_;

	my $nodeseq = $context->{nodeseq};
	#print Dumper $nodeseq;

	# simple demo sub. we pretend we test something in the state we're passed in,
	# and we just say "yes" and descend into our nodeseq. let's pretend that instead of
	# us actually exec'ing the nodeseq, we return it and allow the calling code to descend it
	#print "in AWPTest::yes!\n";
	#print Dumper $context;
	
	$context->{bindings}->{f}->{first_name} = "jerry";
	$context->{bindings}->{f}->{last_name} = "garcia";

	$context->{node}->walk_and_collect($context, $cb);
	
}

sub rows {
	my ($self, $context, $cb) = @_;

	my $nodeseq = $context->{nodeseq};

	my @out;

	my $on = 0; my $seen = scalar(@$nodeseq); my @out;
	foreach my $n (@$nodeseq) {
		$context->{bindings}->{rows}->{id} = $on;
		$n->walk($context, sub {
			my ($dat) = @_;
			$out[$on] = $dat;
			$on += 1;
			$seen -= 1;
			if ($seen == 0) {
				$cb->(join('',@out));
			}
		});
		
	}


}

sub no {
	my ($self, $context, $cb) = @_;

	# don't descend into nodeseq
	$cb->();
}

1;	
