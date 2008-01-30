use inc::Module::Install;

name 'CatalystX-Controller-Tabs';
all_from 'lib/CatalystX/Controller/Tabs.pm';

requires        'Catalyst::Controller';
requires        'NEXT';
build_requires  'Catalyst::Runtime';
build_requires  'Test::WWW::Mechanize::Catalyst';
build_requires  'Test::More';

WriteAll();
