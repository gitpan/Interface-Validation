# Interface::Validation Execution Class
package Interface::Validation::Execution;

use Bubblegum;
use Function::Parameters;
use Moose;

use Interface::Validation::Container;
use Interface::Validation::Document;
use Interface::Validation::Execution::Error;
use Interface::Validation::Failure;
use Try::Tiny;

use Bubblegum::Constraints -minimal;
use Clone 'clone';
use Scalar::Util 'blessed';

our $VERSION = '0.01_01'; # VERSION

has 'data' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1
);

has 'data_fields' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_data_fields',
);

method _build_data_fields {
    my $container     = Interface::Validation::Container->new;
    my $field_matches = $self->field_matches;

    for my $field_name ($field_matches->keys->list) {
        for my $data_point ($field_matches->get($field_name)->list) {
            $container->set($data_point => $field_name);
        }
    }

    return $container;
}

has 'data_matches' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_data_matches',
);

method _build_data_matches {
    my $spec      = $self->specification;
    my $container = Interface::Validation::Container->new;
    my $document  = $spec->documents->get($self->document)
        or Interface::Validation::Failure->raise(
            class   => 'document/unknown',
            name    => $self->document,
            verbose => 1,
        );

    my $data_points = $self->data_points;
    for my $criterion ($document->criteria->keys->list) {
        my $matches = $document->match_criterion(
            $criterion => {$data_points->list}
        );
        $container->set($criterion => $matches);
    }

    return $container;
}

has 'data_points' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_data_points',
);

method _build_data_points {
    my $spec     = $self->specification;
    my $document = $spec->documents->get($self->document)
        or Interface::Validation::Failure->raise(
            class   => 'document/unknown',
            name    => $self->document,
            verbose => 1,
        );

    return Interface::Validation::Container->new(
        $document->collapse_data($self->data)
    );
}

has 'document' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'errors' => (
    is      => 'ro',
    isa     => 'Interface::Validation::Container',
    default => sub { Interface::Validation::Container->new }
);

has 'fields' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_fields',
);

method _build_fields {
    my $spec   = $self->specification;
    my $fields = Interface::Validation::Container->new;

    # clone fields
    for my $field_name ($spec->fields->keys->list) {
        my $field = $spec->fields->get($field_name);
        $fields->set($field_name => clone $field);
    }

    # apply mixins
    for my $field_name ($fields->keys->list) {
        my $field = $fields->get($field_name);
        my $mixin_names = $field->directives->delete('mixin') or next;
        $mixin_names = $mixin_names->args;
        unless (isa_arrayref $mixin_names) {
            $mixin_names = [
                isa_coderef $mixin_names ?
                    $mixin_names->() : $mixin_names
            ];
        }
        for my $mixin_name ($mixin_names->list) {
            my $mixin = $spec->mixins->get($mixin_name)
                or Interface::Validation::Failure->raise(
                    class   => 'directive/mixin/unknown',
                    field   => $field_name,
                    mixin   => $mixin_name,
                    verbose => 1,
                );
            for my $directive_name ($mixin->directives->keys->list) {
                my $template = $mixin->directives->get($directive_name);
                if (my $directive = $field->directives->get($directive_name)) {
                    $directive->mixin($template);
                } else {
                    $field->directive($directive_name => $template->args);
                }
            }
        }
    }

    # apply field mixins
    for my $field_name ($fields->keys->list) {
        my $field = $fields->get($field_name);
        my $template_names = $field->directives->delete('mixin_field') or next;
        $template_names = $template_names->args;
        unless (isa_arrayref $template_names) {
            $template_names = [
                isa_coderef $template_names ?
                    $template_names->() : $template_names
            ];
        }
        for my $template_name ($template_names->list) {
            my $template = $fields->get($template_name)
                or Interface::Validation::Failure->raise(
                    class   => 'directive/field/unknown',
                    field   => $field_name,
                    other   => $template_name,
                    verbose => 1,
                );
            for my $directive_name ($template->directives->keys->list) {
                my $foreign = $template->directives->get($directive_name);
                if (my $directive = $field->directives->get($directive_name)) {
                    $directive->mixin($foreign);
                } else {
                    $field->directive($directive_name => $foreign->args);
                }
            }
        }
    }

    return $fields;
}

has 'fields_for_after' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_fields_for_after',
);

method _build_fields_for_after {
    my $fields = clone $self->fields;

    # register fields for the after event
    for my $field_name ($fields->keys->list) {
        my $field      = $fields->get($field_name);
        my $directives = $field->directives;
        my $found      = 0;
        for my $directive_name ($directives->keys->list) {
            my $directive = $directives->get($directive_name);
            ++$found and next if $directive->does(
                'Interface::Validation::DirectiveRole::Execute::OnAfter'
            );
            $directives->delete($directive_name);
        }
        $fields->delete($field_name) unless $found;
    }

    return $fields;
}

has 'fields_for_before' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_fields_for_before',
);

method _build_fields_for_before {
    my $fields = clone $self->fields;

    # register fields for the validate event
    for my $field_name ($fields->keys->list) {
        my $field      = $fields->get($field_name);
        my $directives = $field->directives;
        my $found      = 0;
        for my $directive_name ($directives->keys->list) {
            my $directive = $directives->get($directive_name);
            ++$found and next if $directive->does(
                'Interface::Validation::DirectiveRole::Execute::OnBefore'
            );
            $directives->delete($directive_name);
        }
        $fields->delete($field_name) unless $found;
    }

    return $fields;
}

has 'fields_for_finish' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_fields_for_finish',
);

method _build_fields_for_finish {
    my $fields = clone $self->fields;

    # register fields for the validate event
    for my $field_name ($fields->keys->list) {
        my $field      = $fields->get($field_name);
        my $directives = $field->directives;
        my $found      = 0;
        for my $directive_name ($directives->keys->list) {
            my $directive = $directives->get($directive_name);
            ++$found and next if $directive->does(
                'Interface::Validation::DirectiveRole::Execute::OnFinish'
            );
            $directives->delete($directive_name);
        }
        $fields->delete($field_name) unless $found;
    }

    return $fields;
}

has 'fields_for_postfilter' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_fields_for_postfilter',
);

method _build_fields_for_postfilter {
    my $fields = clone $self->fields;

    # register fields for the validate event
    for my $field_name ($fields->keys->list) {
        my $field      = $fields->get($field_name);
        my $directives = $field->directives;
        my $found      = 0;
        for my $directive_name ($directives->keys->list) {
            my $directive = $directives->get($directive_name);
            ++$found and next if $directive->does(
                'Interface::Validation::DirectiveRole::Execute::OnPostFilter'
            );
            $directives->delete($directive_name);
        }
        $fields->delete($field_name) unless $found;
    }

    return $fields;
}

has 'fields_for_prefilter' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_fields_for_prefilter',
);

method _build_fields_for_prefilter {
    my $fields = clone $self->fields;

    # register fields for the validate event
    for my $field_name ($fields->keys->list) {
        my $field      = $fields->get($field_name);
        my $directives = $field->directives;
        my $found      = 0;
        for my $directive_name ($directives->keys->list) {
            my $directive = $directives->get($directive_name);
            ++$found and next if $directive->does(
                'Interface::Validation::DirectiveRole::Execute::OnPreFilter'
            );
            $directives->delete($directive_name);
        }
        $fields->delete($field_name) unless $found;
    }

    return $fields;
}

has 'fields_for_start' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_fields_for_start',
);

method _build_fields_for_start {
    my $fields = clone $self->fields;

    # register fields for the validate event
    for my $field_name ($fields->keys->list) {
        my $field      = $fields->get($field_name);
        my $directives = $field->directives;
        my $found      = 0;
        for my $directive_name ($directives->keys->list) {
            my $directive = $directives->get($directive_name);
            ++$found and next if $directive->does(
                'Interface::Validation::DirectiveRole::Execute::OnStart'
            );
            $directives->delete($directive_name);
        }
        $fields->delete($field_name) unless $found;
    }

    return $fields;
}

has 'fields_for_validate' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_fields_for_validate',
);

method _build_fields_for_validate {
    my $fields = clone $self->fields;

    # register fields for the validate event
    for my $field_name ($fields->keys->list) {
        my $field      = $fields->get($field_name);
        my $directives = $field->directives;
        my $found      = 0;
        for my $directive_name ($directives->keys->list) {
            my $directive = $directives->get($directive_name);
            ++$found and next if $directive->does(
                'Interface::Validation::DirectiveRole::Execute::OnValidate'
            );
            $directives->delete($directive_name);
        }
        $fields->delete($field_name) unless $found;
    }

    return $fields;
}

has 'field_matches' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    lazy     => 1,
    builder  => '_build_field_matches',
);

method _build_field_matches {
    my $spec      = $self->specification;
    my $container = Interface::Validation::Container->new;
    my $document  = $spec->documents->get($self->document)
        or Interface::Validation::Failure->raise(
            class   => 'document/unknown',
            name    => $self->document,
            verbose => 1,
        );

    my $data_matches = $self->data_matches;
    for my $data_match ($data_matches->keys->list) {
        my $field_name = $document->criteria->get($data_match)
            or Interface::Validation::Failure->raise(
                class     => 'document/criteria',
                name      => $self->document,
                criterion => $data_match,
                verbose   => 1,
            );


        my $match_point = $data_matches->get($data_match);
        my $data_point  = $container->get($field_name) // [];

        $data_point->push($match_point->list);
        $container->set($field_name => $data_point);
    }

    return $container;
}

has 'specification' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Specification',
    required => 1
);

has 'stash' => (
    is      => 'ro',
    isa      => 'Interface::Validation::Container',
    default => sub { Interface::Validation::Container->new }
);

method run {
    my $spec = $self->specification;

    my %hooks = (
        start      => 'start',
        prefilter  => 'pre_filter',
        before     => 'before_validate',
        validate   => 'validate',
        after      => 'after_validate',
        postfilter => 'post_filter',
        finish     => 'finish',
    );

    my $data          = $self->data;
    my $data_fields   = $self->data_fields;
    my $data_points   = $self->data_points;
    my $data_matches  = $self->data_matches;
    my $field_matches = $self->field_matches;

    my $document = $spec->documents->get($self->document)
        or Interface::Validation::Failure->raise(
            class   => 'document/unknown',
            name    => $self->document,
            verbose => 1,
        );

    for my $hook (keys %hooks) {
        my $routine = "fields_for_${hook}";
        my $fields  = $self->$routine;

        next if ! $fields->keys->count;
        for my $criterion ($document->criteria->keys->list) {
            my $matches = $data_matches->get($criterion) // [];

            unless ($matches->count) {
                # does the corresponding field have
                # a required or present directive? if not, fail
                die "NO MATCH FOUND"; # !!! Interface::Validation::Error
            }
            for my $match ($matches->list) {
                my $routine    = $hooks{$hook};
                my $param      = $data_points->{$match};
                my $field_name = $data_fields->get($match);
                my $field      = $fields->get($field_name);

                for my $directive_name ($field->directives->keys->list) {
                    my $directive = $field->directives->get($directive_name);
                    try {
                        $directive->$routine(
                            $self, $field, $param
                        );
                    } catch {
                        my $exception = $_;
                        die $_ if blessed($_) &&
                            ! $_->isa('Interface::Validation::Failure');

                        my $class = join '::', __PACKAGE__, 'Error';
                        my $name  = "$match#$directive_name";
                        my %args  = (
                            criterion  => $criterion,
                            directive  => $directive_name,
                            document   => $self->document,
                            field      => $exception->field->name,
                            data_point => $match,
                            data_value => $param,
                            message    => $exception->message,
                            phase      => "on_${hook}",
                        );

                        # !!! Interface::Validation::Error::Directive
                        $self->errors->set($name => $class->new(%args));
                    }
                }
            }
        }
    }

    return $self;
}

1;
