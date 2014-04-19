# Interface::Validation OnFinish Field Directive Execution Role
package Interface::Validation::DirectiveRole::Execute::OnStart;

use Bubblegum;
use Function::Parameters;
use Moose::Role;

with 'Interface::Validation::DirectiveRole::Execute';

our $VERSION = '0.01_01'; # VERSION

requires 'finish';

1;
