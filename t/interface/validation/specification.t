use strict;
use warnings;

use Test::More;
use Interface::Validation::Specification;

my $class   = 'Interface::Validation::Specification';
my @attrs   = qw(fields mixins);
my @methods = qw(validate);
can_ok $class => ('new', @attrs, @methods);

ok my $spec = $class->new;
ok $spec->field('firstname', required => 1, min_length => 1, mixin => 'basic');
ok $spec->mixin('basic', required => 1, min_length => 22, max_length => 255);
ok $spec->document(
    name     => 'user/new',
    criteria => {
        'id'              => 'string',
        'name.first_name' => 'string',
        'name.last_name'  => 'string',
    }
);

done_testing;
