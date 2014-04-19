# Interface::Validation Illegal Mixin Directive Failure Class
package Interface::Validation::Failure::Directive::Mixin::Illegal;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure::Directive::Mixin';

our $VERSION = '0.01_01'; # VERSION

has 'object' => (
    is       => 'ro',
    isa      => 'Object',
    required => 1
);

method BUILD {
    my $object = $self->object;
    my $type   = 'Object';

    $type = 'Field' if 'Interface::Validation::Field' eq ref $object;
    $type = 'Mixin' if 'Interface::Validation::Mixin' eq ref $object;

    my $isa = 'Interface::Validation::Directive';

    my $message   = join ' ', (
        "The target $type can't mix-in the supplied object:",
        "the object does not appear to be a directive (not a $isa)"
    );

    $self->message($message);
    return $self;
}

1;
