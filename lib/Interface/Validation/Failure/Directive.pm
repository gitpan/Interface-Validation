# Interface::Validation Directive Failure Base Class
package Interface::Validation::Failure::Directive;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure';

our $VERSION = '0.01_01'; # VERSION

has 'directive' => (
    is       => 'ro',
    isa      => 'Str',
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

1;
