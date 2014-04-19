# Interface::Validation Validator Directive Length
package Interface::Validation::Directive::Validator::Length;

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
    # TODO ...
}

method validate {
    # TODO ...
}

1;
