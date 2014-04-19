use strict;
use warnings;

use Test::More;
use Interface::Validation::Registry;

my $class   = 'Interface::Validation::Registry';
my @attrs   = qw(controls filters validators);
my @methods = qw(directive);
can_ok $class => ('new', @attrs, @methods);

my %controls = (
    alias       => 'Interface::Validation::Directive::Alias',
    default     => 'Interface::Validation::Directive::Default',
    error       => 'Interface::Validation::Directive::Error',
    filter      => 'Interface::Validation::Directive::Filter',
    filtering   => 'Interface::Validation::Directive::Filtering',
    label       => 'Interface::Validation::Directive::Label',
    messages    => 'Interface::Validation::Directive::Messages',
    mixin       => 'Interface::Validation::Directive::Mixin',
    mixin_field => 'Interface::Validation::Directive::MixinField',
    name        => 'Interface::Validation::Directive::Name',
);

my %validators = (
    between     => 'Interface::Validation::Directive::Validator::Between',
    depends_on  => 'Interface::Validation::Directive::Validator::DependsOn',
    length      => 'Interface::Validation::Directive::Validator::Length',
    matches     => 'Interface::Validation::Directive::Validator::Matches',
    max_alpha   => 'Interface::Validation::Directive::Validator::MaxAlpha',
    max_digits  => 'Interface::Validation::Directive::Validator::MaxDigits',
    max_length  => 'Interface::Validation::Directive::Validator::MaxLength',
    max_sum     => 'Interface::Validation::Directive::Validator::MaxSum',
    max_symbols => 'Interface::Validation::Directive::Validator::MaxSymbols',
    min_alpha   => 'Interface::Validation::Directive::Validator::MinAlpha',
    min_digits  => 'Interface::Validation::Directive::Validator::MinDigits',
    min_length  => 'Interface::Validation::Directive::Validator::MinLength',
    min_sum     => 'Interface::Validation::Directive::Validator::MinSum',
    min_symbols => 'Interface::Validation::Directive::Validator::MinSymbols',
    multiples   => 'Interface::Validation::Directive::Validator::Multiples',
    options     => 'Interface::Validation::Directive::Validator::Options',
    pattern     => 'Interface::Validation::Directive::Validator::Pattern',
    required    => 'Interface::Validation::Directive::Validator::Required',
    validation  => 'Interface::Validation::Directive::Validator::Validation',
);

my %filters = (
    alpha         => 'Interface::Validation::Directive::Filter::Alpha',
    alpha_numeric => 'Interface::Validation::Directive::Filter::AlphaNumeric',
    autocase      => 'Interface::Validation::Directive::Filter::Autocase',
    capitalize    => 'Interface::Validation::Directive::Filter::Capitalize',
    lowercase     => 'Interface::Validation::Directive::Filter::Lowercase',
    numeric       => 'Interface::Validation::Directive::Filter::Numeric',
    strip         => 'Interface::Validation::Directive::Filter::Strip',
    titlecase     => 'Interface::Validation::Directive::Filter::Titlecase',
    trim          => 'Interface::Validation::Directive::Filter::Trim',
    uppercase     => 'Interface::Validation::Directive::Filter::Uppercase',
);

isa_ok my $object = $class->new, $class, 'registry instantiated';

is_deeply $object->controls,   \%controls,   'controls loaded properly';
is_deeply $object->filters,    \%filters,    'filters loaded properly';
is_deeply $object->validators, \%validators, 'validators loaded properly';

done_testing;
