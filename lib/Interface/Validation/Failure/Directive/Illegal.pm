# Interface::Validation Illegal Directive Failure Class
package Interface::Validation::Failure::Directive::Illegal;

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
        "the directive is prohibited from being applied to a \L$type object"
    );

    $self->message($message);
    return $self;
}

1;
