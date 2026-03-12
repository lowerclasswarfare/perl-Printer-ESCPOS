use strict;
use warnings;

package Printer::ESCPOS::Connections::File;

# PODNAME: Printer::ESCPOS::Connections::File
# ABSTRACT: Bare Device File Connection Interface for L<Printer::ESCPOS>
#
# This file is part of Printer-ESCPOS
#
# This software is copyright (c) 2017 by Shantanu Bhadoria.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
our $VERSION = '1.006'; # VERSION

# Dependencies

use 5.010;
use Moo;
with 'Printer::ESCPOS::Roles::Connection';

use IO::File;


has deviceFilePath => ( is => 'ro', );

has _connection => (
    is       => 'lazy',
    init_arg => undef,
);

sub _build__connection {
    my ($self) = @_;

    # Ensure the path exists
    die "deviceFilePath is required for File driver" unless $self->deviceFilePath;

    # Open for appending in binary mode
    my $printer = IO::File->new( $self->deviceFilePath, ">>" )
        or die "Could not open " . $self->deviceFilePath . ": $!";

    # Crucial for ESC/POS: Don't let Perl mess with the bytes
    binmode($printer);

    return $printer;
}

#sub _build__connection {
#    my ($self) = @_;
#    my $printer;
#
#    $printer = new IO::File ">>" . $self->deviceFilePath;
#
#    return $printer;
#}

sub write {
    my ($self, $chunk) = @_;

    $self->_connection->print($chunk);

    $self->_connection->autoflush(1);
    return;
}

no Moo;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Printer::ESCPOS::Connections::File - Bare Device File Connection Interface for L<Printer::ESCPOS>

=head1 VERSION

version 1.006

=head1 ATTRIBUTES

=head2 deviceFilePath

This variable contains the path for the printer device file on UNIX-like systems.

=head1 AUTHOR

Shantanu Bhadoria <shantanu@cpan.org> L<https://www.shantanubhadoria.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Shantanu Bhadoria.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
