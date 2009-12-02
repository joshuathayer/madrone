package AWP::Parser;

use strict;

use XML::Parser;
use Data::Dumper;
use AWP::GenericNode;
use AWP::DataNode;
use AWP::ClassNode;
use AWP::BindingNode;

sub new {
	my $class = shift;

	my $self = {};

	$self->{stack} = [];
	$self->{root} = AWP::GenericNode->new();

	unshift(@{$self->{stack}}, $self->{root});
	$self->{onNode} = @{$self->{stack}}[0]->{nodes};
	$self->{chunk} = '';

	$self->{onFunc} = undef;

	bless($self, $class);

	my $p = new XML::Parser(Handlers=>{
		Start => sub {
			my $ex = shift;
			my $el = shift;
			my @attributes = @_;
			if ($el =~ /left:(.*)/) {
				my $func = $1;

				# it's a control tag. we make a data node from our current $chunk
				my $node = AWP::DataNode->new();
				$node->setData($self->{chunk});

				push(@{$self->{onNode}}, $node);

				my ($mod, $sub) = $func =~ /(.*)\.(.*)/;
				my $instance = new $mod;
				#print "instance is $instance (sub $sub)\n";

				# then make a new node for this func
				#my $node = AWP::ClassNode->new(); # jt 20091201 warnings was warning about this my
				$node = AWP::ClassNode->new();
				$node->setFunction($func);

				# put this node at the head of the stack...
				unshift(@{$self->{stack}}, $node);

				# an point onNode to its list of nodes (so new (inner) nodes
				# go in its list)
				$self->{onNode} = $self->{stack}->[0]->{nodes};

				$self->{chunk} = '';

			} elsif ($el =~ /(.*):(.*)/) {
				# it's a binding object!
				my ($bind_object, $bind_var) = ($1, $2);

				# if there is chunk data, we need to make a note of it
				my $node = AWP::DataNode->new();
				$node->setData($self->{chunk});
				push(@{$self->{onNode}}, $node);

				# make a node for this binding...
				my $nnode = AWP::BindingNode->new();
				$nnode->setBindObject($bind_object);
				$nnode->setBindVar($bind_var);

				# put this node at the head of the stack...
				unshift(@{$self->{stack}}, $nnode);

				# an point onNode to its list of nodes (so new (inner) nodes
				# go in its list)
				$self->{onNode} = $self->{stack}->[0]->{nodes};

				$self->{chunk} = '';
			} else {
				$self->{chunk} .= "<$el";
				while (scalar(@attributes)) {
					my $at = shift @attributes;
					my $v = shift @attributes;
					$self->{chunk} .= " $at=\"$v\"";
				}

				$self->{chunk} .= ">";
			}
		},
		End => sub {
			my ($ex, $el) = @_;
			if ($el =~ /(.*):(.*)/) {
				# we've closed a 'left' tag
				# or a bind tag...
				my $func = $1;

				# do we have data? if so, we need to make a data node for it...
				if (length($self->{chunk})) {
					my $node = AWP::DataNode->new();
					$node->setData($self->{chunk});
					push(@{$self->{onNode}}, $node);

					$self->{chunk} = '';
				}

				# pop that node off the head of the stack, since we've closed it
				my $node = shift @{$self->{stack}};

				# and point onNode to the new head of the stack
				$self->{onNode} = $self->{stack}->[0]->{nodes};

				# also, since we're done with that entire node, we can add it to the end of the
				# containing node's list
				push(@{$self->{onNode}}, $node);
			} else {
				$self->{chunk} .= "</$el>";
			}
		},
		Final => sub {
			my $node = AWP::DataNode->new();
			$node->setData($self->{chunk});
			push(@{$self->{onNode}}, $node);
		},
		Default => sub {
			my ($ex, $dat) = @_;
			$self->{chunk} .= "$dat";
		},

	});

	$self->{p} = $p;

	return $self;
}

sub includeMods {
	# all the regexen are for untainting for testing 
	my $self = shift;
	my $path = shift;

	($path) = $path =~ /(.*)/;

	opendir(DIR, $path);
	my @a = grep(/\.pm$/,readdir(DIR));
	closedir(DIR);

	$self->{mods} = \@a;

	foreach my $m (@{$self->{mods}}) {
		($m) = $m =~ /(.*)/;
		require $path.'/'.$m;	# check for errors: there will be some!
		# probably want to eval { } this... XXX
	}

	return 1;
}

sub parsefile {
	my $self = shift;
	my $fn = shift;
	$self->{p}->parsefile($fn);
}

sub walk {
	my ($self, $context, $bindings, $cb) = @_;
	
	my $r = $self->{root}->walk($context, $bindings, sub {
		$cb->(@_);
		$self->{root}->reset();
	});
}

1;
