# Interface::Validation Execution Error Class
package Interface::Validation::Execution::Error;

use Bubblegum;
use Function::Parameters;
use Moose;

our $VERSION = '0.01_01'; # VERSION

has 'criterion' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'directive' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'document' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'field' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'data_point' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'data_value' => (
    is       => 'ro',
    isa      => 'Maybe[Str]',
    required => 1
);

has 'message' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'phase' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

1;
