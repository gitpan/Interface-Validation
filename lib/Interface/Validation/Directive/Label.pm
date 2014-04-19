# Interface::Validation Control Directive Label
package Interface::Validation::Directive::Label;

use Bubblegum;
use Function::Parameters;
use Moose;

our $VERSION = '0.01_01'; # VERSION

extends 'Interface::Validation::Directive';
with    'Interface::Validation::DirectiveRole::Field';

1;
