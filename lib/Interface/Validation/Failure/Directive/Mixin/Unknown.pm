# Interface::Validation Unknown Mixin Directive Failure Class
package Interface::Validation::Failure::Directive::Mixin::Unknown;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure::Directive::Mixin';

our $VERSION = '0.01_01'; # VERSION

has 'field' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'mixin' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

method BUILD {
    my $field = $self->field;
    my $mixin = $self->mixin;

    my $message = join ' ', (
        "The field ($field) can't mix-in the supplied mixin ($mixin):",
        "the mixin is unknown, i.e. it was not found in the mixins",
        "collection"
    );

    $self->message($message);
    return $self;
}

1;
