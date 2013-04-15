use strict;
use warnings;
use utf8;
use Test::More;

use BSpell;

my $engine = BSpell->new();
for (qw(good How darken lived studies How AUTHORS)) {
    ok($engine->is_good_word('good'));
}
ok(!$engine->is_good_word('dankogai'));

done_testing;

