# ABSTRACT: Hierarchical Data Validation à la Moose
package Interface::Validation;

use Bubblegum;
use Function::Parameters;
use Moose;

use Interface::Validation::Specification;

our $VERSION = '0.01_01'; # VERSION

sub import {
    my $target = caller;
    my $class  = shift;

    no strict 'refs';
    push @{"${target}::ISA"}, __PACKAGE__;
}

method initialize {
    # TODO ...
    return Interface::Validation::Specification->new(@_);
}

method validate {
    # TODO ...
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Interface::Validation - Hierarchical Data Validation à la Moose

=head1 VERSION

version 0.01_01

=head1 SYNOPSIS

    use Interface::Validation;

=head1 DESCRIPTION

Interface::Validation is an scalable data validation library with interfaces for
applications of all sizes. The most common usage of Interface::Validation is to
transform class namespaces into data validation domains where consistency and
reuse are primary objectives. Interface::Validation provides an extensible
framework for defining reusable data validation rules. This library is based-on
the architectural pattern found in L<Validation::Class> and is a Moose-based
implementation of its successor L<Validation::Interface>. It ships with a
complete set of pre-defined validations and filters referred to as directives.
B<Note: This is an early release available for testing and feedback and as such
is subject to change.>

The main features included in this framework are; hierarchical data validation;
trait-like validation rules; validation templates; enabling input filtering
per-validator before and after validation; a DSL for domain-modeling supporting
class inheritance; overriding default error messages with localization support;
creating custom validators; creating custom input filters; a simple plugin
system; and much more. Interface::Validation promotes DRY (don't repeat
yourself) code. The main benefit in using Interface::Validation is that the
architecture is designed to increase the consistency and ease of validating
hierarchical data input.

=encoding utf8

=head1 SEE ALSO

L<Interface::Validation::Whitepaper>, L<Interface::Validation::Cookbook>.

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
