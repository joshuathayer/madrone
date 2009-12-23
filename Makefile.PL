use inc::Module::Install;

# Define metadata
name         'awp';
author       'Joshua Thayer <joshuamilesthayer@gmail.com>';
license	     'perl';
perl_version '5.005';
all_from     'lib/AWP.pm';

# Specific dependencies
build_requires	'Test::More';
requires	'Sisyphus'	=> '0.01';

auto_install;

WriteAll;

