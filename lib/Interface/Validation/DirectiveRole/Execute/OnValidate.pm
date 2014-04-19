# Interface::Validation OnValidate Field Directive Execution Role
package Interface::Validation::DirectiveRole::Execute::OnValidate;

use Bubblegum;
use Function::Parameters;
use Moose::Role;
use Try::Tiny;

use Bubblegum::Constraints -minimal;
use Scalar::Util 'blessed';

with 'Interface::Validation::DirectiveRole::Execute';

our $VERSION = '0.01_01'; # VERSION

requires 'validate';

around validate => sub {
    my $orig  = shift;
    my $self  = _object shift;
    my $exec  = _object shift;
    my $field = _object shift;
    my $param = shift;
    my @args  = ($exec, $field, $param);

    return $self->exception(@args)
        if ! defined $param || $param eq '';

    try {
        return $orig->($self, @args);
    } catch {
        die $_ if blessed($_) &&
            ! $_->isa('Interface::Validation::Failure');
        return $self->exception(@args);
    };
};

1;
