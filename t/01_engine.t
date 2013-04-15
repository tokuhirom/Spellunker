use strict;
use warnings;
use utf8;
use Test::More;

use Test::Spelling::Lite;

my $engine = Test::Spelling::Lite::Engine->new();
ok($engine->is_good_word('good'));
ok($engine->is_good_word('How'));
ok($engine->is_good_word('darken'));
ok($engine->is_good_word('lived'));
ok($engine->is_good_word('studies'));
ok($engine->is_good_word('How'));
ok($engine->is_good_word('AUTHORS'));
ok(!$engine->is_good_word('dankogai'));

done_testing;

