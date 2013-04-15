package BSpell;
use strict;
use warnings FATAL => 'all';
use utf8;
use 5.008001;

use version; our $VERSION = version->declare("v0.0.1");

use BSpell::WordList;
use Lingua::EN::Inflect qw();
use File::Spec ();
use Regexp::Common qw /URI/;

# Ref http://www.din.or.jp/~ohzaki/mail_regex.htm#Simplify
my $MAIL_REGEX = (
    q{(?:[-!#-'*+/-9=?A-Z^-~]+(?:\.[-!#-'*+/-9=?A-Z^-~]+)*|"(?:[!#-\[\]-} .
    q{~]|\\\\[\x09 -~])*")@[-!#-'*+/-9=?A-Z^-~]+(?:\.[-!#-'*+/-9=?A-Z^-~]+} .
    q{)*}
);

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->add_stopwords(BSpell::WordList->load_word_list);
    $self->load_user_dict();
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

    # 19xx 2xx
    return 1 if $word =~ /^[0-9]+(xx|yy)$/;

    # Method name
    return 1 if $word =~ /\A([a-zA-Z0-9]+_)+[a-zA-Z0-9]+\z/;

    # Ignore 3 or 4 capital letter words like RFC, IETF.
    return 1 if $word =~ /\A[A-Z]{3,4}\z/;

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

sub check_line {
    my ($self, $line) = @_;

    my @bad_words;
    for ( grep /\S/, split /[~\|*=\[\]\/`"><': \t,.()?;!-]+/, $line) {
        s/\n//;

        next if /^[0-9]+$/;
        next if /^[A-Za-z]$/; # skip single character
        next if /^[%\$\@*][A-Za-z_][A-Za-z0-9_]*$/; # perl variable


        $self->is_good_word($_)
            or push @bad_words, $_;
    }
    return @bad_words;
}

sub clean_text {
    my ($self, $text) = @_;
    return unless $text;

    $text =~ s!<$MAIL_REGEX>|$MAIL_REGEX!!; # Remove E-mail address.
    $text =~ s!$RE{URI}{HTTP}!!g; # Remove HTTP URI
    $text =~ s!\(C\)!!gi; # Copyright mark
    $text =~ s/(\w+::)+\w+/ /gs;    # Remove references to Perl modules
    $text =~ s/\s+/ /gs;
    $text =~ s/[()\@,;:"\/.]+/ /gs;     # Remove punctuation

    return $text;
}

1;
__END__

=encoding utf-8

=head1 NAME

BSpell - It's new module

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

