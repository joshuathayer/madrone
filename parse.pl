use XML::Parser;
use Data::Dumper;
use strict;

use GenericNode;
use DataNode;
use ClassNode;
use BindingNode;

# we want
#{
#	func => "root",
#	type => "func",
#	nodes => [
#		{
#			type => "data",
#			data => "<html>are you logged in?<br>",
#		},
#		{
#			type => "func",
#			func => "Util.in",
#			nodes => [
#				{
#					type => "data",
#					data => "<h1>you are logged in</h1>",
#				},
#			],
#		},
#		{
#			type => "data",
#			data => "ok bye!</html>",
#		}
#	]
#}

my @stack;

my $root = GenericNode->new();

unshift(@stack, $root);
my $onNode = $stack[0]->{nodes};
my $chunk = '';

my @mods = <./subs/*>;
foreach my $m (@mods) {
	#print "mod $m\n";
	require $m;
}

my $onFunc = undef;

my $p = new XML::Parser(Handlers=>{
		Start=> sub {
			my $ex = shift;
			my $el = shift;
			my @attributes = @_;
			if ($el =~ /left:(.*)/) {
				my $func = $1;

				# it's a control tag. we make a data node from our current $chunk
				my $node = DataNode->new();
				$node->setData($chunk);

				push(@$onNode, $node);

				my ($mod, $sub) = $func =~ /(.*)\.(.*)/;
				my $instance = new $mod;
				#print "instance is $instance (sub $sub)\n";

				# then make a new node for this func
				my $node = ClassNode->new();
				$node->setFunction($func);

				# put this node at the head of the stack...
				unshift(@stack, $node);

				# an point onNode to its list of nodes (so new (inner) nodes
				# go in its list
				$onNode = $stack[0]->{nodes};

				$chunk = '';

			} elsif ($el =~ /(.*):(.*)/) {
				# it's a binding object!
				my ($bind_object, $bind_var) = ($1, $2);

				# if there is chunk data, we need to make a note of it
				my $node = DataNode->new();
				$node->setData($chunk);
				push(@$onNode, $node);

				# make a node for this binding...
				my $node = BindingNode->new();
				$node->setBindObject($bind_object);
				$node->setBindVar($bind_var);

				# put this node at the head of the stack...
				unshift(@stack, $node);

				# an point onNode to its list of nodes (so new (inner) nodes
				# go in its list
				$onNode = $stack[0]->{nodes};

				$chunk = '';
			} else {
				$chunk .= "<$el";
				while (scalar(@attributes)) {
					my $at = shift @attributes;
					my $v = shift @attributes;
					$chunk .= " $at=\"$v\"";
				}

				$chunk .= ">";
			}

		},
		End => sub {
			my ($ex, $el) = @_;
			if ($el =~ /(.*):(.*)/) {
				# we've closed a 'left' tag
				# or a bind tag...
				my $func = $1;

				# do we have data? if so, we need to make a data node for it...
				if (length($chunk)) {
					my $node = DataNode->new();
					$node->setData($chunk);
					push(@$onNode, $node);

					$chunk = '';
				}

				# pop that node off the head of the stack, since we've closed it
				my $node = shift @stack;

				# and point onNode to the new head of the stack
				$onNode = $stack[0]->{nodes};

				# also, since we're done with that entire node, we can add it to the end of the
				# containing node's list
				push(@$onNode, $node);
			} else {
				$chunk .= "</$el>";
			}
		},
		Final => sub {
			my $node = DataNode->new();
			$node->setData($chunk);
			push(@$onNode, $node);
		},
		Default => sub {
			my ($ex, $dat) = @_;
			$chunk .= "$dat";
		},

	});
$p -> parsefile("test.xml");

my @out;
my @instances;

open DFH, ">dumper.out";
print DFH Dumper $root;
close DFH;

my $out = $root->walk();
print $out;
exit;

sub walknodes {
	my $node = shift;
	my $nodeseq = $node->{nodes};


	my $containing_instance;

	foreach my $n (@$nodeseq) {

		if ($n->{type} eq "data") {
			push(@out, $n->{data});
		} elsif ($n->{type} eq "func") {
			my $func = $n->{func};
			my ($mod, $sub) = $func =~ /(.*)\.(.*)/;
			
			#print "containing_instance $containing_instance, func $func\n";

			# so the way this works now (and might not work in the future)
			# is that our call rewrites our node sequence (we might (?) want the
			# call itself to descend into the node seq)
			$n->{nodes} = $n->{instance}->$sub($n->{nodes});

			# so. we keep track of our containing classes by sticking them
			# on an array. when we try to do variable sub, we'll walk this
			# array and look for data for our variable subs
			unshift @instances, $n->{instance};
			# make the recursive call...
			walknodes($n);
			# when we're back from recursion, we don't have use for this
			# containing instance...
			shift @instances;

		} elsif ($n->{type} eq "bind") {
			# wtf do we do, here...
			# there needs to be state. which includes scalar values for
			# bind variables. in fact, the outside function should have set up the 
			# bind objects... so, here, we can assume that there 

			my $obj = $n->{obj};
			my $var = $n->{var};
			#print "looking for binding for $obj.$var\n";
			my $dat;
			foreach my $i (@instances) {
				$dat = $i->getBinding($obj, $var);
				last if $dat ne '';
			}

			# guess we assume that the things in the binding hash are just 
			# "scalar" data chunks, we push them on. if we ever want to interpret
			# what's in the binding hash, we would need to do this differently here
			push(@out, $dat);
		} else {
			print "unknown node type " . $n->{type} . "\n";
		}
	}
}	

walknodes($root, []);

open DFH, ">dumper.out";
print DFH Dumper $root;
close DFH;

open FH, ">output.xml";
print FH join('',@out);
close FH;
