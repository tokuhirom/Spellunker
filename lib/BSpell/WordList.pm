package BSpell::WordList;
use strict;
use warnings;
use utf8;
use BSpell::WordList::Enable1;
use BSpell::WordList::Perl;

sub load_word_list {
    (
        BSpell::WordList::Enable1->load_word_list(),
        BSpell::WordList::Perl->load_word_list(),
    );
}

1;

