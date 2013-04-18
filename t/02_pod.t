use strict;
use warnings;
use utf8;
use Test::More;
BEGIN { $ENV{PERL_SPELLUNKER_NO_USER_DICT} = 1 }

use Spellunker::Pod;

subtest 'ok' => sub {
    my $sp = Spellunker::Pod->new();
    my @ret = $sp->check_file('t/dat/ok.pod');
    is(0+@ret, 0);
};

subtest 'fail' => sub {
    my $sp = Spellunker::Pod->new();
    my @ret = $sp->check_file('t/dat/fail.pod');
    is(0+@ret, 1);
    is_deeply( \@ret, [ [ 6, 'gah', 'aaaaaaaaaaaaaaaaaaa' ] ] );
};

done_testing;

