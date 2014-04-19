use strict;
use warnings;

use Test::More;
use Interface::Validation::Directive::Validator::Between;
use Interface::Validation::Execution;
use Interface::Validation::Specification;

my $class     = 'Interface::Validation::Directive::Validator::Between';
my @attrs     = qw(args args_list);
my @methods   = qw(error exception validate);

can_ok $class => ('new', @attrs, @methods);

my $spec = Interface::Validation::Specification->new;

my $rule = $spec->field(
    rule_1 => (
        between => [5,10]
    )
);

my $document = $spec->document(
    document_1 => (
        criteria => {
            'zipcode.@' => 'rule_1'
        }
    )
);

my $params = {
    zipcode => [ 999999, 44456, '78901-2345' ]
};

my $exec   = $spec->validate(document_1 => $params);
my $errors = $exec->errors;
is $errors->count, 0, 'no errors found';

$params = {
    zipcode => [ 123, 44456, '78901-2345' ]
};

$exec = $spec->validate(document_1 => $params);
$errors = $exec->errors;
is $errors->count, 1, '1 error found';
my $error = $errors->get('zipcode:0#between');
isa_ok $error, 'Interface::Validation::Execution::Error',
    'failure zipcode:0#between found';
is $error->data_point, 'zipcode:0', 'error data_point expected';
is $error->data_value, 123, 'error data_value expected';

done_testing;
