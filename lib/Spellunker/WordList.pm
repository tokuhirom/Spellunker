package Spellunker::WordList;
use strict;
use warnings;
use utf8;
use Spellunker::WordList::Enable1;
use Spellunker::WordList::Perl;

sub load_word_list {
    (
        Spellunker::WordList::Enable1->load_word_list(),
        Spellunker::WordList::Perl->load_word_list(),
    );
}

1;

