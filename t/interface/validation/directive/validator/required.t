use strict;
use warnings;

use Test::More;
use Interface::Validation::Directive::Validator::Required;
use Interface::Validation::Execution;
use Interface::Validation::Specification;

my $class     = 'Interface::Validation::Directive::Validator::Required';
my @attrs     = qw(args args_list);
my @methods   = qw(error exception start);

can_ok $class => ('new', @attrs, @methods);

my $spec = Interface::Validation::Specification->new;

my $rule = $spec->field(
    rule_1 => (
        required => 1
    )
);

my $document = $spec->document(
    document_1 => (
        criteria => {
            'name'                    => 'rule_1',
            'company.supervisor.name' => 'rule_1',
        }
    )
);

my $params = {
    name    => "Anita Campbell-Green",
    company => {supervisor => {name => "Cruella de Vil",}}
};

my $exec = $spec->validate(document_1 => $params);
my $errors = $exec->errors;
is $errors->count, 0, 'no errors found';

undef $params->{name};

$exec = $spec->validate(document_1 => $params);
$errors = $exec->errors;
is $errors->count, 1, '1 error found';
my $error = $errors->get('name#required');
isa_ok $error, 'Interface::Validation::Execution::Error',
    'failure name#required found';
is $error->data_point, 'name', 'error data_point expected';
is $error->data_value, undef, 'error data_value expected';

done_testing;
