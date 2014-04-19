use strict;
use warnings;

use Test::More;
use Interface::Validation::Specification;
use Interface::Validation::Execution;

my $class   = 'Interface::Validation::Execution';
my @attrs   = qw(fields specification);
my @methods = qw(run);

can_ok $class => ('new', @attrs, @methods);

my $spec = Interface::Validation::Specification->new;

my $f1 = $spec->field(
    first_name => (
        required => 1
    )
);

my $f2 = $spec->field(
    last_name => (
        required => 0
    )
);

my $d = $spec->document(
    default => (
        criteria => {
            'name.first_name' => 'first_name',
            'name.last_name'  => 'last_name',
        }
    )
);

my $data = {
    "id"=> "1234-A",
    "name"=> {
        "first_name" => undef,
        "last_name"  => undef,
     },
    "title"=> "CIO",
    "friends" => [],
};

ok my $exec = $spec->validate(default => $data);
ok $exec->errors->count;

done_testing;
