# Interface::Validation Execution Failure Class
package Interface::Validation::Failure::Execution;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure';

our $VERSION = '0.01_01'; # VERSION

has 'field' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Field',
    required => 1
);

has 'message' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has 'object' => (
    is       => 'ro',
    isa      => 'Object',
    required => 1
);

has 'param' => (
    is       => 'ro',
    isa      => 'Maybe[Str]',
    required => 1
);

1;
