#!/usr/bin/perl

use strict;
use warnings;

use lib qw(blib/lib blib/arch);

use Simple::Class::Private::Data::Any;

{
	package ZZ;

	sub DESTROY { print "DESTROYED\n"; }
}

{
	package DOG;

	sub DESTROY { print "DOG\n"; }
}

my $dog = bless {}, 'DOG';

my $z = bless {'cat' => $dog }, 'ZZ';
undef($dog);
my $c = Simple::Class::Private::Data::Any->new('dog' => 'mouse', '_private' => $z);
undef $z;
undef $c;
print "end\n";

my $x;
while (1) {
	my $obj = [];
	my $c = Simple::Class::Private::Data::Any->new('dog' => 'mouse', '_private' => $obj);
	$x = $c;
	$x->display;
}

$x->display;
