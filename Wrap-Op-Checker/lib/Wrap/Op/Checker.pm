package Wrap::Op::Checker;
# ABSTRACT - An example XS wrap_op_check implementation 

# wrap_op_checker added in 5.16.0
use 5.016000;

our $VERSION = '0.01';

use strict;
use warnings;

require XSLoader;
XSLoader::load('Wrap::Op::Checker', $VERSION);

1;
__END__

=head1 NAME

Wrap::Op::Checker - An example XS wrap_op_check implementation 

=head1 SYNOPSIS

  use Wrap::Op::Checker;

  print "Const!\n";

=head1 DESCRIPTION

This package shows how to use L<perlapi/"wrap_op_checker"> to install
custom Op checker routines.

See L<Checker.xs> for the implementation.

=head1 SEE ALSO

L<perlapi/"wrap_op_checker"> - Core documentation for I<wrap_op_checker>.

=head1 AUTHOR

Matthew Horsfall (alh) - <wolfsage@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Matthew Horsfall

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
