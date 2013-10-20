use strict;
use warnings;
use utf8;
use Test::More;

BEGIN { $ENV{PERL_SPELLUNKER_NO_USER_DICT} = 1 }

use Spellunker;

my $spellunker = Spellunker->new();

$spellunker->add_stopwords('foobarbaz');

ok $spellunker->check_word('foobarbaz');
ok !$spellunker->check_word('aaabbbcccddd');

$spellunker->use_dictionary(\*DATA);

ok !$spellunker->check_word('foobarbaz');
ok $spellunker->check_word('aaabbbcccddd');

done_testing;

__DATA__
aaabbbcccddd
