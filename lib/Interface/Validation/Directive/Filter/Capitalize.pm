# Interface::Validation Filter Directive Capitalize
package Interface::Validation::Directive::Filter::Capitalize;

use Bubblegum;
use Function::Parameters;
use Moose;

use Bubblegum::Constraints -minimal;

our $VERSION = '0.01_01'; # VERSION

extends 'Interface::Validation::Directive';
with    'Interface::Validation::DirectiveRole::Field';
with    'Interface::Validation::DirectiveRole::Filter';
with    'Interface::Validation::DirectiveRole::Mixin::Default';

1;
