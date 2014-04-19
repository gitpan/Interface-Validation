# Interface::Validation OnPostFilter Field Directive Execution Role
package Interface::Validation::DirectiveRole::Execute::OnPostFilter;

use Bubblegum;
use Function::Parameters;
use Moose::Role;

with 'Interface::Validation::DirectiveRole::Execute';

our $VERSION = '0.01_01'; # VERSION

requires 'post_filter';

1;
