# NAME

BSpell - Pure perl spelling checker implementation

# DESCRIPTION

BSpell is pure perl spelling checker implementation.
You can use this spelling checker as a library.

And this distribution provides [bspell](http://search.cpan.org/perldoc?bspell) and [bspell-pod](http://search.cpan.org/perldoc?bspell-pod) command.

If you want to use this spelling checker in test script, you can use [Test::BSpell](http://search.cpan.org/perldoc?Test::BSpell).

# METHODS

- my $bspell = BSpell->new();

    Create new instance.

- $bspell->add\_stopwords(@stopwords)

    Add some `@stopwords` to the on memory dictionary.

- $bspell->check\_word($word);

    Check the word looks good or not.

- @bad\_words = $bspell->check\_line($line)

    Check the text and returns bad word list.

# HOW DO I USE CUSTOM DICTIONARY?

You can put your personal dictionary at `$HOME/.bspell.en`.

# LICENSE

Copyright (C) tokuhirom

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokuhirom <tokuhirom@gmail.com>
