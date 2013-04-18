use strict;
use warnings;
use utf8;
use Test::More;

use Spellunker;
use Data::Dumper;

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
is(0+$engine->check_line("It isn't"), 0, 'short hand');
is(0+$engine->check_line("You can pass a %args."), 0, 'short hand');
is(0+$engine->check_line('Use \%hashref'), 0, 'hashref');
is(0+$engine->check_line('Use \@val'), 0, 'array');
is(0+$engine->check_line("You can't"), 0, "can't");
is(0+$engine->check_line("O'Reilly"), 0, "O'Reilly");
is(0+$engine->check_line("'quoted'"), 0, "Quoted words");
is(0+$engine->check_line("'em"), 0, "'em");

while (<DATA>) {
    chomp;
    my @ret = $engine->check_line($_);
    is(0+@ret, 0, $_) or diag Dumper(\@ret);
}

done_testing;

__DATA__
cookies'
you've
You've
We're
mod_perl's
It doesn't
You'll
rename any non-standard executables so the names do not conflict with
Ingy döt Net
re-enabled
iterator
'xism' flag.
