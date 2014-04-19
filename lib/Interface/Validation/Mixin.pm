# Interface::Validation Mixin Class
package Interface::Validation::Mixin;

use Bubblegum;
use Function::Parameters;
use Moose;

use Interface::Validation::Container;
use Interface::Validation::Failure;
use Interface::Validation::Registry;

use Bubblegum::Constraints -minimal;
use Class::Load 'load_class';

our $VERSION = '0.01_01'; # VERSION

has 'directives' => (
    is      => 'ro',
    isa     => 'Interface::Validation::Container',
    default => sub { Interface::Validation::Container->new }
);

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub BUILDARGS {
    my ($class, @args) = @_;
    return {@args % 2 == 1 ? ('name', @args) : @args};
}

method directive {
    my $name     = _string shift;
    my $args     = _defined shift;
    my $registry = Interface::Validation::Registry->new;

    $self->validate($name, $args);

    my $class = $registry->directive($name);
    my $directive = $class->new(args => $args);

    $self->directives->set($name, $directive);

    return $self;
}

method validate {
    my $name     = _string shift;
    my $args     = _defined shift;
    my $registry = Interface::Validation::Registry->new;
    my $found    = load_class $registry->directive($name);

    unless ($found) {
        Interface::Validation::Failure->raise(
            class     => 'directive/unknown',
            directive => $name,
            object    => $self,
            verbose   => 1,
        );
    }

    unless ($found->does('Interface::Validation::DirectiveRole::Mixin')) {
        Interface::Validation::Failure->raise(
            class     => 'directive/illegal',
            directive => $name,
            object    => $self,
            verbose   => 1,
        );
    }

    my $valid = (
        isa_string($args)
        or isa_arrayref($args)
        or isa_coderef($args)
    );

    unless ($valid) {
        Interface::Validation::Failure->raise(
            class     => 'directive/arguments',
            directive => $name,
            object    => $self,
            verbose   => 1,
        );
    }

    return $self;
}

1;
