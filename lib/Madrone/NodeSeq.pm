package Madrone::NodeSeq;

use strict;
use Data::Dumper;

sub new {
    my ($class, $nodes) = @_;

    $nodes = defined($nodes) ? $nodes : [];

    my $self = {
        nodes => $nodes, 
    };

    bless $self, $class;
    return $self;
}

sub length {
    my $self = shift;
    return scalar @{$self->{nodes}};
}

# return a nodeseq consitsing of exactly one instance of a subnode of a particular name
sub oneNode {
    my ($self, $term) = @_;

    return $self->grepNodes($term, 1);
}

# return a nodeseq consisting of all subnodes of a particular name
sub grepNodes {
    my ($self, $term, $justone) = @_;

#if (defined($self->{cached_searches}->{$term})) {
#       return $self->{cached_searches}->{$term};
#   }

    my $ret = Madrone::NodeSeq->new();

    foreach my $n (@{$self->{nodes}}) {

        if (($n->{type} eq 'class') and ($n->{'sub'} =~ /$term/)) {
            $ret->push($n);
            return $ret if $justone;
        }

    }

    $self->{cached_searches}->{$term} = $ret;
    return $ret;
}

sub iterator {
    my ($self) = @_;
    my $itr = Madrone::Iterator->new($self);
    return $itr;
}

sub push {
    my ($self, $item) = @_;

    push(@{$self->{nodes}}, $item);
}

sub walk_all_nodes {
    my ($self, $context, $bindings, $cb, $per_sub) = @_;

    if (not (defined ($bindings))) { $bindings = {}; }

    my @out;
    my $on;
    my $len = $self->length;
    my $iterator = $self->iterator;

    while (my $n = $iterator->next()) {
        my $onn = $on;  # need a new lexically-scoped var for the closure

        # if the user has provided a per-subnode callback, call it
        # here. in this way, user code can modify bindings. note
        # however that there is no nonblocking interface.
        if (($n->{type} eq 'class') and (defined($per_sub->{ $n->{'sub'} }))) {
            $per_sub->{ $n->{'sub'} }->( $bindings );
        }

        my $collector = sub {
            my $dat = shift;
            $dat = $dat ? $dat : '';
            $out[$onn] = $dat;
            if (--$len== 0) {
                $cb->( join('', @out) );
            }
        };

        $n->walk($context, $bindings, $collector);

        $on++;
    }

}


1;

package Madrone::Iterator;
use strict;

sub new {
    my ($class, $nodeseq) = @_;

    my $self = {
        nodeseq => $nodeseq,
        on => 0,
    };

    bless($self, $class);

    return $self;
}

sub next {
    my ($self) = @_;

    if ($self->{on} > $self->{nodeseq}->length) {
        return undef;
    } else {
        my $ret = $self->{nodeseq}->{nodes}->[ $self->{on} ];
        $self->{on}++;
        return $ret;
    }
}
