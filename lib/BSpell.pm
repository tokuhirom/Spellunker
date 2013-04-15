package BSpell;
use strict;
use warnings;
use utf8;

use BSpell::WordList;
use Lingua::EN::Inflect qw();

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->add_stopwords(BSpell::WordList->load_word_list);
    return $self;
}

sub add_stopwords {
    my $self = shift;
    for (@_) {
        $self->{stopwords}->{$_}++
    }
    return undef;
}

sub is_good_word {
    my ($self, $word) = @_;
    return 0 unless defined $word;

    # good
    return 1 if $self->{stopwords}->{$word};

    # 'How'
    if ($word =~ /\A[A-Z][a-z]+\z/) {
        return 1 if $self->{stopwords}->{lc $word};
    }

    # AUTHORS
    if ($word =~ /\A[A-Z]+\z/) {
        return 1 if $self->{stopwords}->{lc $word};
    }

    return 0;
}

1;

