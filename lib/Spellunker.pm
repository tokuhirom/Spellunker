package Spellunker;
use strict;
use warnings FATAL => 'all';
use utf8;
use 5.008001;

use version; our $VERSION = version->declare("v0.0.3");

use Spellunker::WordList::Perl;
use File::Spec ();
use File::ShareDir ();
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
    $self->add_stopwords(Spellunker::WordList::Perl->load_word_list);

    # From https://code.google.com/p/dotnetperls-controls/downloads/detail?name=enable1.tx
    $self->load_dictionary(File::Spec->catfile(File::ShareDir::dist_dir('Spellunker'), 'enable1.txt'));

    $self->_load_user_dict();
    return $self;
}

sub _load_user_dict {
    my $self = shift;
    my $home = $ENV{HOME};
    return unless -d $home;
    my $dictpath = File::Spec->catfile($home, '.spellunker.en');
    if (-f $dictpath) {
    }
}

sub load_dictionary {
    my ($self, $filename) = @_;
    open my $fh, '<', $filename
        or die "Cannot open '$filename' for reading: $!";
    while (<$fh>) {
        chomp;
        $self->add_stopwords($_);
    }
}

sub add_stopwords {
    my $self = shift;
    for (@_) {
        $self->{stopwords}->{$_}++
    }
    return undef;
}

sub check_word {
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
        return $self->check_word($body);
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
        return $self->check_word($nt);
    }

    return 0;
}

sub check_line {
    my ($self, $line) = @_;

    $line = $self->_clean_text($line);

    my @bad_words;
    for ( grep /\S/, split /[~\|*=\[\]\/`"><': \t,.()?;!-]+/, $line) {
        s/\n//;

        next if /^[0-9]+$/;
        next if /^[A-Za-z]$/; # skip single character
        next if /^[%\$\@*][A-Za-z_][A-Za-z0-9_]*$/; # perl variable


        $self->check_word($_)
            or push @bad_words, $_;
    }
    return @bad_words;
}

sub _clean_text {
    my ($self, $text) = @_;
    return unless $text;

    $text =~ s!<$MAIL_REGEX>|$MAIL_REGEX!!; # Remove E-mail address.
    $text =~ s!$RE{URI}{HTTP}!!g; # Remove HTTP URI
    $text =~ s!\(C\)!!gi; # Copyright mark
    $text =~ s/(\w+::)+\w+/ /gs;    # Remove references to Perl modules
    $text =~ s/\s+/ /gs;
    $text =~ s/[()\@,;:"\/.]+/ /gs;     # Remove punctuation
    $text =~ s/you'll/you will/gs;

    return $text;
}

1;
__END__

=encoding utf-8

=head1 NAME

Spellunker - Pure perl spelling checker implementation

=head1 DESCRIPTION

Spellunker is pure perl spelling checker implementation.
You can use this spelling checker as a library.

And this distribution provides L<spellunker> and L<spellunker-pod> command.

If you want to use this spelling checker in test script, you can use L<Test::Spellunker>.

=head1 METHODS

=over 4

=item my $spellunker = Spellunker->new();

Create new instance.

=item $spellunker->add_stopwords(@stopwords)

Add some C<< @stopwords >> to the on memory dictionary.

=item $spellunker->check_word($word);

Check the word looks good or not.

=item @bad_words = $spellunker->check_line($line)

Check the text and returns bad word list.

=back

=head1 HOW DO I USE CUSTOM DICTIONARY?

You can put your personal dictionary at C<$HOME/.spellunker.en>.

=head1 LICENSE

Copyright (C) tokuhirom

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

