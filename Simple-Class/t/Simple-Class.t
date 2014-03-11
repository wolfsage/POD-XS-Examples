#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Capture::Tiny qw(capture_stdout);

use Data::Dumper;

use Simple::Class;

my $obj = Simple::Class->new(
	'cat' => 'dog',
	'bird' => 1,
);
ok($obj, 'Got an object');
isa_ok($obj, 'Simple::Class', 'obj is the correct class');

# Check hash entries are correct
is($obj->{cat}, 'dog', 'private member cat is correct');
is($obj->{bird}, 1, 'private member bird is correct');

# Check display method works
my $exp1 = <<EOF;
Self:
	cat: dog
	bird: 1
EOF

my $exp2 = <<EOF;
Self:
	bird: 1
	cat: dog
EOF

my $stdout = capture_stdout { $obj->display };

ok(($stdout eq $exp1) || ($stdout eq $exp2), "display() works")
	or diag("Got $stdout, expected $exp1 or $exp2");

# Make sure stored data isn't references to *OUR* data
my $dog = 'dog';

my $obj = Simple::Class->new(
	'cat' => $dog,
	'bird' => 1,
);
ok($obj, 'Got an object');
isa_ok($obj, 'Simple::Class', 'obj is the correct class');

$dog = 'not a dog';

# Check hash entries are correct
is($obj->{cat}, 'dog', 'private member cat is correct');
is($obj->{bird}, 1, 'private member bird is correct');

done_testing;
