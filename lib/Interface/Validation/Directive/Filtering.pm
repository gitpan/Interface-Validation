# Interface::Validation Control Directive Filtering
package Interface::Validation::Directive::Filtering;

use Bubblegum;
use Function::Parameters;
use Moose;

our $VERSION = '0.01_01'; # VERSION

extends 'Interface::Validation::Directive';
with    'Interface::Validation::DirectiveRole::Field';
with    'Interface::Validation::DirectiveRole::Mixin::Default';

1;
