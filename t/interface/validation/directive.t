use strict;
use warnings;

use Test::More;
use Interface::Validation::Directive;

my $class   = 'Interface::Validation::Directive';
my @attrs   = qw(args);
my @methods = qw(args_list);

can_ok $class => ('new', @attrs, @methods);
isa_ok my $object = $class->new(args => sub{[1,2,3]}), $class;
is 'CODE', ref $object->args, 'data is a coderef';
is_deeply $object->args_list, [1,2,3];

subtest 'test directive mixin - default' => sub {
    package A1;
    use parent 'Interface::Validation::Directive::Validator::Required';
    package main;

    my $a = A1->new(args => 123);
    my $b = A1->new(args => 456);

    ok $a->does('Interface::Validation::DirectiveRole::Mixin::Default'),
        'object ($a) does Interface::Validation::DirectiveRole::Mixin::Default';
    ok $a->does('Interface::Validation::DirectiveRole::Mixin'),
        'object ($a) does Interface::Validation::DirectiveRole::Mixin';

    ok $a->mixin($b), 'object (a) mixed-in directive object (b)';
    is $a->args_list, 456, 'object (a) returns mixed-in data from object (b)';
};

subtest 'test directive mixin - merger w/strings' => sub {
    package A2;
    use parent 'Interface::Validation::Directive::Filter';
    package main;

    my $a = A2->new(args => 123);
    my $b = A2->new(args => [456, 789]);
    my $c = A2->new(args => [456, 321]);

    ok $a->does('Interface::Validation::DirectiveRole::Mixin::Merger'),
        'object ($a) does Interface::Validation::DirectiveRole::Mixin::Merger';
    ok $a->does('Interface::Validation::DirectiveRole::Mixin'),
        'object ($a) does Interface::Validation::DirectiveRole::Mixin';

    ok $a->mixin($b), 'object (a) mixed-in directive object (b)';
    ok $a->mixin($c), 'object (a) mixed-in directive object (c)';
    is_deeply [$a->args_list], [123,456,789,321],
        'object (a) returns unique-merged-mixed-in data from object (b,c)';
};

subtest 'test directive mixin - merger w/objects' => sub {
    package A3;
    use parent 'Interface::Validation::Directive::Filter';
    package main;

    my $a = A3->new(args => 123);
    my $b = A3->new(args => [qr/456/, qr/789/]);
    my $c = A3->new(args => [qr/456/, qr/321/]);

    ok $a->does('Interface::Validation::DirectiveRole::Mixin::Merger'),
        'object ($a) does Interface::Validation::DirectiveRole::Mixin::Merger';
    ok $a->does('Interface::Validation::DirectiveRole::Mixin'),
        'object ($a) does Interface::Validation::DirectiveRole::Mixin';

    ok $a->mixin($b), 'object (a) mixed-in directive object (b)';
    ok $a->mixin($c), 'object (a) mixed-in directive object (c)';
    is_deeply [$a->args_list], [123,qr/456/,qr/789/,qr/321/],
        'object (a) returns unique-merged-mixed-in data from object (b,c)';
};

done_testing;
