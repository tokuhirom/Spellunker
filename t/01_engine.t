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

is(0+$engine->check_line("It isn't"), 0);
is(0+$engine->check_line("<% \$module %>"), 0, 'in some case, Pod::Simple takes data from __DATA__ section.');
is(0+$engine->check_line("# What I think"), 0, 'Ignore Markdown-ish header');
is(0+$engine->check_line("You _know_ it"), 0, 'Plain text mark up');
is(0+$engine->check_line("You *know* it"), 0, 'Plain text mark up');
is(0+$engine->check_line("It doesn't"), 0, 'short hand');
is(0+$engine->check_line("It isn't"), 0, 'short hand');
is(0+$engine->check_line("You can pass a %args."), 0, 'short hand');
is(0+$engine->check_line('Use \%hashref'), 0, 'hashref');
is(0+$engine->check_line('Use \@val'), 0, 'array');

done_testing;

