use strict;
use warnings;

use Test::More;
use Interface::Validation;

my $class = 'Interface::Validation';
my $spec  = 'Interface::Validation::Specification';
can_ok $class => ('import', 'new', 'initialize', 'validate');
ok + main->isa($class);

done_testing;
