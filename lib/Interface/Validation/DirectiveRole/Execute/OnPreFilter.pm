# Interface::Validation OnPreFilter Field Directive Execution Role
package Interface::Validation::DirectiveRole::Execute::OnPreFilter;

use Bubblegum;
use Function::Parameters;
use Moose::Role;

with 'Interface::Validation::DirectiveRole::Execute';

our $VERSION = '0.01_01'; # VERSION

requires 'pre_filter';

1;
