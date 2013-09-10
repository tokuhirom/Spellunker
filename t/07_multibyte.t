use strict;
use warnings;
use Test::More;

use Spellunker;

my $spell= Spellunker->new();
ok !$spell->check_line('testあああああああああああああああああああああああああああああああああああああああ');

done_testing;

