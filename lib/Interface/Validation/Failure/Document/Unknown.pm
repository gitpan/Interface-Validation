# Interface::Validation Unknown Document Failure Class
package Interface::Validation::Failure::Document::Unknown;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Interface::Validation::Failure::Document';

our $VERSION = '0.01_01'; # VERSION

method BUILD {
    my $name = $self->name;
    my $message = join ' ', (
        "Document ($name) is unknown or not accessible, ",
        "i.e. it was not found in the documents collection",
    );

    $self->message($message);
    return $self;
}

1;
