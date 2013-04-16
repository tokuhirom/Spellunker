# NAME

Spellunker - Pure perl spelling checker implementation

# DESCRIPTION

Spellunker is pure perl spelling checker implementation.
You can use this spelling checker as a library.

And this distribution provides [spellunker](http://search.cpan.org/perldoc?spellunker) and [spellunker-pod](http://search.cpan.org/perldoc?spellunker-pod) command.

If you want to use this spelling checker in test script, you can use [Test::Spellunker](http://search.cpan.org/perldoc?Test::Spellunker).

# METHODS

- my $spellunker = Spellunker->new();

    Create new instance.

- $spellunker->add\_stopwords(@stopwords)

    Add some `@stopwords` to the on memory dictionary.

- $spellunker->check\_word($word);

    Check the word looks good or not.

- @bad\_words = $spellunker->check\_line($line)

    Check the text and returns bad word list.

# HOW DO I USE CUSTOM DICTIONARY?

You can put your personal dictionary at `$HOME/.spellunker.en`.

# LICENSE

Copyright (C) tokuhirom

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokuhirom <tokuhirom@gmail.com>
