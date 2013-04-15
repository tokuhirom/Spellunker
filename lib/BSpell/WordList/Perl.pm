package BSpell::WordList::Perl;
use strict;
use warnings;
use utf8;

# Perl/CPAN/Computer specific word list.

sub load_word_list {
    my @tech_words = qw(
        https
        C
        gmail
        FAQ
        URL
        http
        perl
        ftp
        gopher
        php
    );
    my @web_service_name = qw(
        lingr
        gmail
    );
    my @perl_words = qw(
        XS
        Furl
        LWP
    );
    my @moose_words = qw(
        Str
        Int
        ArrayRef
        HashRef
    );
    my @authors = qw(
        Tokuhiro Matsuno
        Kazuho Oku
        audreyt
        lestrrat
        mattn
        walf443
        mala
        gfx
        Goro Fuji
        Dan Kogai
        dankogai
        tokuhirom
    );
    my @misc_words = qw(
        perl
        19xx
        19yy
        USA
    );
    return (@tech_words, @moose_words, @web_service_name, @perl_words, @authors, @misc_words);
}

1;

