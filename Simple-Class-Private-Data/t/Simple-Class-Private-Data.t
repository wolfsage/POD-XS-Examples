#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Capture::Tiny qw(capture_stdout);

use Data::Dumper;

use Simple::Class::Private::Data;

my $obj = Simple::Class::Private::Data->new(
	'cat' => 'dog',
	'_private' => 'moose',
);
ok($obj, 'Got an object');
isa_ok($obj, 'Simple::Class::Private::Data', 'obj is the correct class');

# Check hash entries are correct
is($obj->{cat}, 'dog', 'private member cat is correct');
is(0+keys %$obj, 1, 'object only has 1 key');

# Check display method works
my $exp = <<EOF;
Self:
	cat: dog
	(private): moose
EOF

my $stdout = capture_stdout { $obj->display };

is($stdout, $exp, "display() works")
	or diag("Got $stdout, expected $exp");

done_testing;
