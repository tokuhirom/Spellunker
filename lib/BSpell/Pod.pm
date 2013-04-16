package BSpell::Pod;
use strict;
use warnings;
use utf8;
use BSpell;
use BSpell::Pod::Parser;

sub new {
    my $class = shift;
    bless {bspell => BSpell->new()}, $class;
}

sub _check_parser {
    my ($self, $parser) = @_;

    # '=for stopwords'
    for my $stopwords (@{$parser->stopwords}) {
        $self->{bspell}->add_stopwords(split /\s+/, $stopwords);
    }

    my $lines = $parser->lines;
    my $line = 0;
    my @rv;
    for my $line ( @$lines ) {
        my $text = $line->[1];
        my @err = $self->{bspell}->check_line($text);
        if (@err) {
            push @rv, [$line->[0], @err];
        }
    }
    return @rv;
}

sub check_file {
    my ($self, $filename) = @_;

    my $parser = BSpell::Pod::Parser->new();
    $parser->parse_file($filename);
    $self->_check_parser($parser);
}

sub check_text {
    my ($self, $text) = @_;

    my $parser = BSpell::Pod::Parser->new();
    $parser->parse_string_document($text);
    $self->_check_parser($parser);
}

1;

