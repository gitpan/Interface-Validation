# Interface::Validation Registry of Directives
package Interface::Validation::Registry;

use Bubblegum;
use Function::Parameters;
use Moose;

use Interface::Validation::Container;

use Bubblegum::Constraints -minimal;
use Class::Load 'load_class';

our $VERSION = '0.01_01'; # VERSION

my @DIRECTIVES = qw(
    Interface::Validation::Directive::Alias
    Interface::Validation::Directive::Default
    Interface::Validation::Directive::Error
    Interface::Validation::Directive::Filter
    Interface::Validation::Directive::Filter::Alpha
    Interface::Validation::Directive::Filter::AlphaNumeric
    Interface::Validation::Directive::Filter::Autocase
    Interface::Validation::Directive::Filter::Capitalize
    Interface::Validation::Directive::Filter::Lowercase
    Interface::Validation::Directive::Filter::Numeric
    Interface::Validation::Directive::Filter::Strip
    Interface::Validation::Directive::Filter::Titlecase
    Interface::Validation::Directive::Filter::Trim
    Interface::Validation::Directive::Filter::Uppercase
    Interface::Validation::Directive::Filtering
    Interface::Validation::Directive::Label
    Interface::Validation::Directive::Messages
    Interface::Validation::Directive::Mixin
    Interface::Validation::Directive::MixinField
    Interface::Validation::Directive::Name
    Interface::Validation::Directive::Validator::Between
    Interface::Validation::Directive::Validator::DependsOn
    Interface::Validation::Directive::Validator::Length
    Interface::Validation::Directive::Validator::Matches
    Interface::Validation::Directive::Validator::MaxAlpha
    Interface::Validation::Directive::Validator::MaxDigits
    Interface::Validation::Directive::Validator::MaxLength
    Interface::Validation::Directive::Validator::MaxSum
    Interface::Validation::Directive::Validator::MaxSymbols
    Interface::Validation::Directive::Validator::MinAlpha
    Interface::Validation::Directive::Validator::MinDigits
    Interface::Validation::Directive::Validator::MinLength
    Interface::Validation::Directive::Validator::MinSum
    Interface::Validation::Directive::Validator::MinSymbols
    Interface::Validation::Directive::Validator::Multiples
    Interface::Validation::Directive::Validator::Options
    Interface::Validation::Directive::Validator::Pattern
    Interface::Validation::Directive::Validator::Required
    Interface::Validation::Directive::Validator::Validation
);

has 'controls' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    required => 1,
);

has 'filters' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    required => 1
);

has 'validators' => (
    is       => 'ro',
    isa      => 'Interface::Validation::Container',
    required => 1
);

sub BUILDARGS {
    my ($class, %args) = @_;

    my %defaults;
    my $namespace  = 'Interface::Validation::Directive';
    my $controls   = Interface::Validation::Container->new;
    my $filters    = Interface::Validation::Container->new;
    my $validators = Interface::Validation::Container->new;

    for my $module (map load_class($_), @DIRECTIVES) {
        my $type = undef;
        my $base = 'Interface::Validation::DirectiveRole';
        my $meta = $module->meta;

        next unless my $name = do {
            my ($subspace) = $module
                =~ /^${namespace}::(?:(?:Filter|Validator)::)?(.*)/;

            $subspace =~ s/([a-z])([A-Z])/$1_$2/g;
            $subspace =~ s/\W+/-/g;

            lc $subspace;
        };

        $type = $validators if !$type && $meta->does_role("${base}::Validator");
        $type = $filters    if !$type && $meta->does_role("${base}::Filter");
        $type = $controls   if !$type;

        $type->set($name => $module);
    }

    $defaults{controls}   = $controls;
    $defaults{filters}    = $filters;
    $defaults{validators} = $validators;

    return {%defaults, %args};
}

method directive {
    my $name = _string shift;

    return $self->controls->get($name)
        || $self->validators->get($name)
        || $self->filters->get($name);
}

1;
