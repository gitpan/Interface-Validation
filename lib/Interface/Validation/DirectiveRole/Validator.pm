# Interface::Validation Validator Directive Role
package Interface::Validation::DirectiveRole::Validator;

use Bubblegum;
use Function::Parameters;
use Moose::Role;

use Interface::Validation::Failure;

use Bubblegum::Constraints -minimal;

our $VERSION = '0.01_01'; # VERSION

requires 'error';

method exception {
    my $exec  = _object shift;
    my $field = _object shift;
    my $error = _string $self->error;
    my $param = shift;

    my $fields = $exec->specification->fields;

    my %format = (
        label => sub {
            my $name  = shift // $field->name;
            my $field = $fields->get($name);
            my $label = $field->directives->get('label');
            return $label ? $label->args_list : $field->name;
        }
    );

    $error =~ s^ (?:\#\{(.+?)(:\w+)?\}) ^ $format{$1}->($2) ^egx;

    Interface::Validation::Failure->raise(
        class   => 'execution',
        message => $error,
        object  => $exec,
        field   => $field,
        param   => $param,
    );
}

1;
