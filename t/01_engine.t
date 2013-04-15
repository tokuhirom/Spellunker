use strict;
use warnings;
use utf8;
use Test::More;

use BSpell;

my $engine = BSpell->new();
for (qw(good How darken lived studies How AUTHORS Dan's)) {
    ok($engine->is_good_word($_), $_);
}
ok(!$engine->is_good_word('gaaaaaa'));

done_testing;

