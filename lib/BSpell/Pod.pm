package BSpell::Pod;
use strict;
use warnings;
use utf8;
use BSpell;
use Pod::POM;

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

{
    package BSpell::Pod::Parser;
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
}

# Note:
# Q. Why not Pod::POM?
# A. I can't handle line number by Pod::POM.

1;

