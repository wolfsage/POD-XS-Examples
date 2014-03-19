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
{
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
}

# Make sure stored strings are not terminated with a null
{
    my $dog = "Dog \x00 Foo";
    my $obj = Simple::Class->new(
    	$dog => 'Fido',
    	'bird' => 1,
    );
    ok($obj, 'Got an object');
    isa_ok($obj, 'Simple::Class', 'obj is the correct class');

    # Check hash entries are correct
    is($obj->{$dog}, $dog, 'private member cat is correct');
}

# Make sure UTF-X strings are stored properly
{
    my $dog = "Dog \x{1F415}";
    my $obj = Simple::Class->new(
    	$dog => $dog
    );
    ok($obj, 'Got an object');
    isa_ok($obj, 'Simple::Class', 'obj is the correct class');


    is($obj->{$dog}, $dog, 'private member is correct');
}

{
    package MyDogNames;
    sub TIESCALAR { return bless \(my $i = 0), shift }

    sub FETCH {
        my ($self) = @_;
        return qw(Skip Lassie)[$$self ^= 1];
    }
}

# Make sure MAGIC strings are stored properly
{
    tie my $name, 'MyDogNames';
    my $obj = Simple::Class->new(
    	$name => "Fido",
    );
    ok($obj, 'Got an object');
    isa_ok($obj, 'Simple::Class', 'obj is the correct class');

    # Check hash entries are correct
    is($obj->{Lassie}, 'Fido', 'private member is correct');
}

{
    use Test::LeakTrace 0.10;
    no_leaks_ok {
        eval { Simple::Class->new(foo => \1) };
    }
}

done_testing;
