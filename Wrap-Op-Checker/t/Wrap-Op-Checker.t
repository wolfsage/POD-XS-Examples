#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Wrap::Op::Checker;

my $x = "hi";
is($x, "hi", "hi not modified");

$x = "Hello world";
is($x, "Hello Perl", "Hello world changed to Hello Perl!");

done_testing;
