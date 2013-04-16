use strict;
use warnings;
use utf8;
use Test::More;
use Test::Spellunker;

add_stopwords("dankogai");

all_pod_files_spelling_ok();

