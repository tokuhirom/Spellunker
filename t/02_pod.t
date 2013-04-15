use strict;
use warnings;
use utf8;
use Test::More;

use BSpell::Pod;

my $sp = BSpell::Pod->new();
my @ret = $sp->check_file('t/dat/ok.pod');
use Data::Dumper; warn Dumper(\@ret);
is(0+@ret, 0);

done_testing;

