package HelloWorld;

use strict;
use utf8;

sub new {
    my $class = shift;
    my $self = {};
    
    # in a real application, you'd initialize DBs and whatnot here

    bless($self, $class);
    return $self;
}

sub Hello {
    my ($self, $context, $bindings, $cb) = @_;

    $bindings->{'helloWorld'}->{'audience'} = "universe";

    $context->{nodeseq}->walk_all_nodes($context, $bindings, $cb);
}

1;
