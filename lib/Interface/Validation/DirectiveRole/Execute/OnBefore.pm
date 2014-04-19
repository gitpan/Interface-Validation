# Interface::Validation OnBefore Field Directive Execution Role
package Interface::Validation::DirectiveRole::Execute::OnBefore;

use Bubblegum;
use Function::Parameters;
use Moose::Role;

with 'Interface::Validation::DirectiveRole::Execute';

our $VERSION = '0.01_01'; # VERSION

requires 'before_validate';

1;
