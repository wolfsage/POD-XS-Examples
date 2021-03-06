package Simple::Class::Private::Data::Any;

use 5.014002;

use strict;
use warnings;

our $VERSION = '0.01';

require Exporter;
our @ISA = qw(Exporter);

require XSLoader;
XSLoader::load('Simple::Class::Private::Data::Any', $VERSION);

1;
__END__

=head1 NAME

Simple::Class::Private::Data::Any - Example class in XS for hiding C data from Perl

=head1 SYNOPSIS

  my $c = Simple::Class::Private::Data::Any->new(%data);

  $c->display;

=head1 DESCRIPTION

An example XS implementation of a Perl class (package) that 
contains private data that's unavailable in Perl land.

=head2 Constructor

=head3 new

  Simple::Class::Private::Data::Any->new('cat' => 'meow');

Creates a new L<Simple::Class::Private::Data::Any> object and copies the
hash passed to C<new()> to it, ensuring that all values
are non-references.

If the key '_private' exists, the object becomes magic
and the data for '_private' is stored where Perl-land can't see it.

Returns the new object.

=head2 Methods

=head3 display

  $obj->display();

Prints out something like:

  Self:
  	key1: val1
  	key2: val2
  	...

If '_private' data was set, C<<display()>> might look like:

  Self:
        key1: val1
        (private): some private val

=head1 AUTHOR

Matthew Horsfall (alh) - <WolfSage@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Matthew Horsfall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
