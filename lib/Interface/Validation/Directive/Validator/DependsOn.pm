# Interface::Validation Validator Directive DependsOn
package Interface::Validation::Directive::Validator::DependsOn;

use Bubblegum;
use Function::Parameters;
use Moose;

use Bubblegum::Constraints -minimal;

our $VERSION = '0.01_01'; # VERSION

extends 'Interface::Validation::Directive';
with    'Interface::Validation::DirectiveRole::Execute::OnValidate';
with    'Interface::Validation::DirectiveRole::Field';
with    'Interface::Validation::DirectiveRole::Mixin::Merger';
with    'Interface::Validation::DirectiveRole::Validator';

method error {
    my @args   = $self->args_list;
    my $fields = pop @args;
    $fields    = join(' and ', join(', ', map "#{label:$_}", @args), $fields);
    return "#{label} requires $fields";
}

method validate {
    my $exec   = _object shift;
    my $field  = _object shift;
    my $fields = $exec->specification->fields;
    my $param  = shift;

    my @args   = map _string($_), $self->args_list;
    my @fields = map _defined($fields->get($_)), @args;

    unless ($exec->matches->get('$_')->count) {
        return $self->exception($exec, $field, $param);
    }

    return;
}

1;
