use 5.016000;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Wrap::Op::Checker',
    VERSION_FROM      => 'lib/Wrap/Op/Checker.pm',
    PREREQ_PM         => {},
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Wrap/Op/Checker.pm',
       AUTHOR         => 'Matthew Horsfall <WolfSage@gmail.com>') : ()),
    LICENSE           => "perl",
);

