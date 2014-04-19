# Interface::Validation Default Field Directive Mixin Role
package Interface::Validation::DirectiveRole::Mixin::Default;

use Bubblegum;
use Function::Parameters;
use Moose::Role;

use Interface::Validation::Failure;

use Bubblegum::Constraints -minimal;

with 'Interface::Validation::DirectiveRole::Mixin';

our $VERSION = '0.01_01'; # VERSION

method mixin {
    my $other = _object shift;

    unless ($other->isa('Interface::Validation::Directive')) {
        Interface::Validation::Failure->raise(
            class     => 'directive/mixin/illegal',
            object    => $self,
            verbose   => 1,
        );
    }

    $self->args($other->args);

    return $self;
}

1;
