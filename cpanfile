requires "Bubblegum" => "0.27";
requires "Class::Forward" => "0.100006";
requires "Class::Load" => "0.21";
requires "Devel::StackTrace" => "1.31";
requires "Function::Parameters" => "1.0401";
requires "Hash::Flatten" => "1.19";
requires "Moose" => "2.1204";
requires "perl" => "v5.14.2";

on 'test' => sub {
  requires "perl" => "v5.14.2";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};
