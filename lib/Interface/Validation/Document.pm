# Interface::Validation Document Class
package Interface::Validation::Document;

use Bubblegum;
use Function::Parameters;
use Moose;

use Interface::Validation::Container;

use Bubblegum::Constraints -minimal;
use Hash::Flatten ':all';

our $VERSION = '0.01_01'; # VERSION

has 'criteria' => (
    is      => 'ro',
    isa     => 'Interface::Validation::Container',
    default => sub { Interface::Validation::Container->new },
);

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub BUILDARGS {
    my ($class, @args) = @_;
    return $args[0] if isa_hashref $args[0];
    return { @args % 2 == 1 ? ('name', @args) : @args };
}

method criterion {
    my $criterion = _string shift;
    my $directive = _string shift;

    $self->criteria->set($criterion => $directive);
    return $self;
}

method collapse_data {
    my $data = _hashref shift;
    return _hashref(flatten($data));
}

method explode_data {
    my $data = _hashref shift;
    return _hashref(unflatten($data));
}

method match_criterion {
    my $query = quotemeta _string shift;
    my $data  = _hashref shift;
    my $keys  = [];

    my $token;
    my $regex;

    $token  = quotemeta '\.\@';
    $regex  = ':\d+';
    $query =~ s/$token/$regex/g;

    $token  = quotemeta '\*';
    $regex  = '[^\.]+';
    $query  =~ s/$token/$regex/g;

    for my $key ($data->keys->list) {
        $keys->push($key) if $key =~ /^$query$/;
    }

    return $keys;
}

1;
