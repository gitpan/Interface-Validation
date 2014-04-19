use strict;
use warnings;

use Test::More;
use Interface::Validation::Document;

my $class   = 'Interface::Validation::Document';
my @attrs   = qw(criteria name);
my @methods = qw(criterion collapse_data explode_data match_criterion);

can_ok $class => ('new', @attrs, @methods);

done_testing;
