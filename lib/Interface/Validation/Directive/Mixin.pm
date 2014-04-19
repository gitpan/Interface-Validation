# Interface::Validation Control Directive Mixin
package Interface::Validation::Directive::Mixin;

use Bubblegum;
use Function::Parameters;
use Moose;

our $VERSION = '0.01_01'; # VERSION

extends 'Interface::Validation::Directive';
with    'Interface::Validation::DirectiveRole::Field';

1;
