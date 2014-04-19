# Interface::Validation Container Class
package Interface::Validation::Container;

use Bubblegum;
use Function::Parameters;
use Moose;

use parent 'Bubblegum::Object::Hash';

our $VERSION = '0.01_01'; # VERSION

sub count { $_[0]->keys->count }
sub new   { bless $_[1] // {}, $_[0] }

1;
