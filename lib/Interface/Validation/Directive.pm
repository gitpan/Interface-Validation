# Interface::Validation Directive Base Class
package Interface::Validation::Directive;

use Bubblegum;
use Function::Parameters;
use Moose;

use Bubblegum::Constraints -minimal;

our $VERSION = '0.01_01'; # VERSION

has 'args' => (
    is       => 'rw',
    isa      => 'Defined',
    required => 1,
);

has 'execution' => (
    is       => 'ro',
    isa      => 'Maybe[Interface::Validation::Execution]',
    required => 0
);

method args_list {
    my $args = _defined $self->args;
    return ($args->(@_)) if isa_coderef  $args;
    return ($args->list) if isa_arrayref $args;
    return ($args);
}

1;
