package Simple::Class;

use 5.014002;

use strict;
use warnings;

our $VERSION = '0.01';

require Exporter;
our @ISA = qw(Exporter);

require XSLoader;
XSLoader::load('Simple::Class', $VERSION);

1;
__END__

=head1 NAME

Simple::Class - Example class in XS

=head1 SYNOPSIS

  my $c = Simple::Class->new(%data);

  $c->display;

=head1 DESCRIPTION

An example XS implementation of a Perl class (package).

=head2 Constructor

=head3 new

  Simple::Class->new('cat' => 'meow');

Creates a new L<Simple::Class> object and copies the
hash passed to C<new()> to it, ensuring that all values
are non-references.

Returns the new object.

=head2 Methods

=head3 display

  $obj->display();

Prints out something like:

  Self:
  	key1: val1
  	key2: val2
  	...

=head1 AUTHOR

Matthew Horsfall (alh) - <WolfSage@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Matthew Horsfall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
