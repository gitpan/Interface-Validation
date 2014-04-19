# Interface::Validation Unknown Field Directive Failure Class
package Interface::Validation::Failure::Directive::Field::Unknown;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure::Directive::Field';

our $VERSION = '0.01_01'; # VERSION

has 'field' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'other' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

method BUILD {
    my $field = $self->field;
    my $other = $self->other;

    my $message = join ' ', (
        "The field ($field) can't mix-in the supplied field ($other):",
        "the field ($other) is unknown, i.e. it was not found in the fields",
        "collection"
    );

    $self->message($message);
    return $self;
}

1;
