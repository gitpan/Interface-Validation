# Interface::Validation Directive Arguments Failure Class
package Interface::Validation::Failure::Directive::Arguments;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure::Directive';

our $VERSION = '0.01_01'; # VERSION

method BUILD {
    my $object    = $self->object;
    my $directive = $self->directive;
    my $type      = 'Object';

    $type = 'Field' if 'Interface::Validation::Field' eq ref $object;
    $type = 'Mixin' if 'Interface::Validation::Mixin' eq ref $object;

    my $message   = join ' ', (
        "$type (@{[$object->name]}) can't apply the directive ($directive):",
        "the arguments suggested are inappropriate, i.e. directive arguments",
        "should be either a constant, scalar, arrayref or coderef"
    );

    $self->message($message);
    return $self;
}

1;
