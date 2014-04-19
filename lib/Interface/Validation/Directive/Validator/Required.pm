# Interface::Validation Validator Directive Required
package Interface::Validation::Directive::Validator::Required;

use Bubblegum;
use Function::Parameters;
use Moose;

use Bubblegum::Constraints -minimal;

our $VERSION = '0.01_01'; # VERSION

extends 'Interface::Validation::Directive';
with    'Interface::Validation::DirectiveRole::Execute::OnStart';
with    'Interface::Validation::DirectiveRole::Field';
with    'Interface::Validation::DirectiveRole::Mixin::Default';
with    'Interface::Validation::DirectiveRole::Validator';

method error {
    return '#{label} is required'
}

method start {
    my $exec  = _object shift;
    my $field = _object shift;

    my $param  = shift;
    my @args = $self->args_list;

    if (scalar _integer $args[0]) {
        return $self->exception($exec, $field, $param)
            if ! defined $param || $param eq '';
    }

    return;
}

1;
