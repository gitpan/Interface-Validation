# Interface::Validation Document Criteria Failure Class
package Interface::Validation::Failure::Document::Criteria;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure::Document';

our $VERSION = '0.01_01'; # VERSION

has 'criterion' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

method BUILD {
    my $name      = $self->name;
    my $criterion = $self->criterion;
    my $message   = join ' ', (
        "Criterion ($criterion) for document ($name) is unknown,",
        "missing or not accessible, i.e. it was not found in the",
        "criteria collection",
    );

    $self->message($message);
    return $self;
}

1;
