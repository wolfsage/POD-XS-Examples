use 5.014002;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Simple::Class',
    VERSION_FROM      => 'lib/Simple/Class.pm',
    PREREQ_PM         => {},
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Simple/Class.pm',
       AUTHOR         => 'Matthew Horsfall <WolfSage@gmail.com>') : ()),
    LICENSE           => "perl",
);

