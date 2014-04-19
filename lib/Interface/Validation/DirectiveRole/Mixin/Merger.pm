# Interface::Validation Merging Field Directive Mixin Role
package Interface::Validation::DirectiveRole::Mixin::Merger;

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

    my $s_data = $self->args;
    my $o_data = $other->args;

    $s_data = [$s_data] unless isa_arrayref $s_data;
    $o_data = [$o_data] unless isa_arrayref $o_data;

    $self->args([$s_data->list, $o_data->list]->unique);

    return $self;
}

1;
