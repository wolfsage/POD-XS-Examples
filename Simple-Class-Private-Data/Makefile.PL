use 5.014002;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Simple::Class::Private::Data',
    VERSION_FROM      => 'lib/Simple/Class/Private/Data.pm',
    PREREQ_PM         => {},
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Simple/Class/Private/Data.pm',
       AUTHOR         => 'Matthew Horsfall <WolfSage@gmail.com>') : ()),
    LICENSE           => "perl",
);

