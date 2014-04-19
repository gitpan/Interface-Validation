# Interface::Validation OnAfter Field Directive Execution Role
package Interface::Validation::DirectiveRole::Execute::OnAfter;

use Bubblegum;
use Function::Parameters;
use Moose::Role;

with 'Interface::Validation::DirectiveRole::Execute';

our $VERSION = '0.01_01'; # VERSION

requires 'after_validate';

1;
