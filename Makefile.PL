use inc::Module::Install;

name     'awp';
all_from 'lib/AWP.pm';
author   'Joshua Thayer <joshuamilesthayer@gmail.com>';

build_requires 'Test::More';
requires	'Sisyphus'		=> 0;

license		'perl';

auto_install;

WriteAll;

