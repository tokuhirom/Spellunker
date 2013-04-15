package BSpell;
use strict;
use warnings FATAL => 'all';
use utf8;

our $VERSION = "0.01";

use BSpell::WordList;
use Lingua::EN::Inflect qw();
use File::Spec ();

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->add_stopwords(BSpell::WordList->load_word_list);
    $self->load_user_dict();
    $self->add_stopwords(qw(
        I
        a
    ));
    return $self;
}

sub load_user_dict {
    my $self = shift;
    my $home = $ENV{HOME};
    return unless -d $home;
    my $dictpath = File::Spec->catfile($home, '.bspell.en');
    if (-f $dictpath) {
        open my $fh, '<', $dictpath
            or die "Cannot open '$dictpath' for reading: $!";
        while (<$fh>) {
            chomp;
            $self->add_stopwords($_);
        }
    }
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

    # "foo" - quoted word
    if (my ($body) = ($word =~ /\A"(.+)"\z/)) {
        return $self->is_good_word($body);
    }

    # Dan's
    $word =~ s!'s$!!;

    # good
    return 1 if $self->{stopwords}->{$word};

    # ucfirst-ed word.
    # 'How'
    # Dan
    if ($word =~ /\A[A-Z][a-z]+\z/) {
        return 1;
    }

    # AUTHORS
    if ($word =~ /\A[A-Z]+\z/) {
        return 1 if $self->{stopwords}->{lc $word};
    }

    # don't
    if (my ($nt) = ($word =~ /\A(.+)n't\z/)) {
        return $self->is_good_word($nt);
    }

    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

BSpell - It's new $module

=head1 DESCRIPTION

BSpell is ...

=head1 HOW DO I USE CUSTOM DICTIONARY?

You can put your personal dictionary at C<$HOME/.bspell.en>.

=head1 LICENSE

Copyright (C) tokuhirom

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

