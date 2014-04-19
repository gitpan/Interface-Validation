# Interface::Validation Document Failure Base Class
package Interface::Validation::Failure::Document;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure';

our $VERSION = '0.01_01'; # VERSION

has 'message' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

1;
