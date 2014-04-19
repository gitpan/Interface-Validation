# Interface::Validation Validation Specification
package Interface::Validation::Specification;

use Bubblegum;
use Function::Parameters;
use Moose;

use Interface::Validation::Container;
use Interface::Validation::Document;
use Interface::Validation::Execution;
use Interface::Validation::Failure;
use Interface::Validation::Field;
use Interface::Validation::Mixin;

use Bubblegum::Constraints -minimal;

our $VERSION = '0.01_01'; # VERSION

has 'fields' => (
    is      => 'ro',
    isa     => 'Interface::Validation::Container',
    default => sub { Interface::Validation::Container->new }
);

has 'mixins' => (
    is      => 'ro',
    isa     => 'Interface::Validation::Container',
    default => sub { Interface::Validation::Container->new }
);

has 'documents' => (
    is      => 'ro',
    isa     => 'Interface::Validation::Container',
    default => sub { Interface::Validation::Container->new }
);

method document {
    my $args = {@_ % 2 == 1 ? ('name', @_) : @_};
    my $bind = $args->delete('criteria');

    my $document = Interface::Validation::Document->new($args);
    $self->documents->set($document->name, $document);

    if ($bind) {
        $document->criterion($_, $bind->get($_)) for $bind->keys->list;
    }

    return $document;
}

method execute {
    # TODO ...
}

method field {
    my $args = {@_ % 2 == 1 ? ('name', @_) : @_};
    my $name = $args->delete('name');

    my $field = Interface::Validation::Field->new($name);
    $self->fields->set($field->name, $field);

    for ($args->keys->list) {
        $field->directive($_, $args->get($_)) unless $field->can($_);
    }

    return $field;
}

method mixin {
    my $args = {@_ % 2 == 1 ? ('name', @_) : @_};
    my $name = $args->delete('name');

    my $mixin = Interface::Validation::Mixin->new($name);
    $self->mixins->set($mixin->name, $mixin);

    for ($args->keys->list) {
        $mixin->directive($_, $args->get($_)) unless $mixin->can($_);
    }

    return $mixin;
}

method prepare {
    # TODO ...
}

method validate {
    my $document = _defined shift;
    my $data     = _hashref shift;

    my $gendoc;
    my @tempfields;
    if (isa_hashref $document) {
        my $count    = 0;
        my $criteria = {};
        while (my ($key, $value) = each %{$document}) {
            if (isa_hashref $value) {
                $count++;
                push @tempfields, (my $name = "#field_${count}");
                $self->field($name => %$value);
                $criteria->{$key} = $name;
            } else {
                $criteria->{$key} = $value;
            }
        }
        $self->document(
            ($document = $gendoc = '#document') => (
                criteria => $criteria
            )
        );
    }

    my $exec = Interface::Validation::Execution->new(
        data          => $data,
        document      => $document,
        specification => $self
    );

    my $result = $exec->run(@_);

    if (@tempfields) {
        $self->fields->delete($_) for @tempfields;
        $self->documents->delete($gendoc);
    }

    return $result;
}

1;
