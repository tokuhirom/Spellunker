package Spellunker::Pod::Parser;
use strict;
use warnings;
use utf8;
use parent qw(Pod::Simple::Methody);

use Carp ();

use constant {
    MODE_STOPWORDS => 1,
    MODE_IGNORE    => 2,
    MODE_NORMAL    => 3,
};

sub new {
    my $self = shift;
    my $new  = $self->SUPER::new(@_);
    $new->{'output_fh'} ||= *STDOUT{IO};
    $new->{mode} = 'normal';
    $new->accept_target_as_text(qw( text plaintext plain stopwords ));
    $new->nix_X_codes(1);
    $new->nbsp_for_S(1);
    return $new;
}

sub stopwords { $_[0]->{stopwords} || [] }
sub lines { $_[0]->{lines} || [] }

sub handle_text {
    my ($self, $text) = @_;
    if ($self->{mode} eq MODE_IGNORE) {
        # nop.
    } elsif ($self->{mode} eq MODE_STOPWORDS) {
        push @{$self->{stopwords}}, $text;
    } else {
        push @{$self->{lines}}, [
            $self->line_count, $text
        ];
    }
}

sub start_encoding { $_[0]->{mode} = MODE_IGNORE }
sub end_encoding   { $_[0]->{mode} = MODE_NORMAL }

sub start_for {
    my ($self, $flags) = @_;
    if ($flags->{target} eq 'stopwords') {
        $self->{mode} = MODE_STOPWORDS;
    }
}

sub end_for {
    my ($self, $flags) = @_;
    $self->{mode} = MODE_NORMAL;
}

for (
    'code',
    'Verbatim',
    'C', # C<>
    'L', # L<>
) {
    no strict 'refs';
    *{"start_$_"} = sub { $_[0]->{mode} = MODE_IGNORE };
    *{"end_$_"}   = sub { $_[0]->{mode} = MODE_NORMAL };
}

1;

