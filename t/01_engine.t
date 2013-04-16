use strict;
use warnings;
use utf8;
use Test::More;

use Spellunker;

my $engine = Spellunker->new();
for (qw(good How darken lived studies How AUTHORS Dan's 19xx 2xx remove_header RFC IETF)) {
    ok($engine->check_word($_), $_);
}
ok(!$engine->check_word('gaaaaaa'));

done_testing;

