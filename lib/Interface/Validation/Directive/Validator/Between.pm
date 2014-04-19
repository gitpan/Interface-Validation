# Interface::Validation Validator Directive Between
package Interface::Validation::Directive::Validator::Between;

use Bubblegum;
use Function::Parameters;
use Moose;

use Bubblegum::Constraints -minimal;

our $VERSION = '0.01_01'; # VERSION

extends 'Interface::Validation::Directive';
with    'Interface::Validation::DirectiveRole::Execute::OnValidate';
with    'Interface::Validation::DirectiveRole::Field';
with    'Interface::Validation::DirectiveRole::Mixin::Default';
with    'Interface::Validation::DirectiveRole::Validator';

method error {
    my @args = $self->args_list;
    my $range = join ' and ', @args;
    return "#{label} must contain between $range characters";
}

method validate {
    my $exec  = _object shift;
    my $field = _object shift;

    my $param = shift;
    my @args  = $self->args_list;

    my $min = _number $args[0];
    my $max = _number $args[1];

    my $value = length($param);
    unless ($value >= $min && $value <= $max) {
        return $self->exception($exec, $field, $param);
    }

    return;
}

1;
