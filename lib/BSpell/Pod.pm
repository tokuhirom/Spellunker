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

sub _check_pom {
    my ($self, $pom) = @_;

    # '=for stopwords'
    for my $for ($pom->for) {
        if ($for->format eq 'stopwords') {
            $self->{bspell}->add_stopwords(split /\s+/, $for->text);
        }
    }

    my $content = BSpell::Pod::POM::View::TextBasic->print($pom);
    my $line = 0;
    my @rv;
    for my $text ( split /[\n\r\f]+/, scalar $content ) {
        $text = $self->{bspell}->clean_text($text);
        my @err = $self->{bspell}->check_line($text);
        if (@err) {
            push @rv, [$line, @err];
        }
        $line++;
    }
    return @rv;
}

sub check_file {
    my ($self, $filename) = @_;

    my $parser = Pod::POM->new();
    my $pom = $parser->parse_file($filename)
        or die $parser->error;
    return $self->_check_pom($pom);
}

sub check_text {
    my ($self, $text) = @_;

    my $parser = Pod::POM->new();
    my $pom = $parser->parse_text($text)
        or die $parser->error;
    return $self->_check_pom($pom);
}

{
    # https://metacpan.org/module/Pod::POM::View::TextBasic
    package BSpell::Pod::POM::View::TextBasic;
    use parent qw( Pod::POM::View );
    use Pod::POM::Constants qw(:seq);
    
    sub new {
        my $class = shift;
        my $args  = ref $_[0] eq 'HASH' ? shift : { @_ };
        bless { 
            %$args,
        }, $class;
    }

    sub view {
        my ( $self, $type, $item ) = @_;

        if ( $type =~ s/^seq_// ) {
            return $item;
        }
        elsif ( UNIVERSAL::isa( $item, 'HASH' ) ) {
            if ( defined $item->{content} ) {
                return $item->{content}->present($self);
            }
            elsif ( defined $item->{text} ) {
                my $text = $item->{text};
                return ref $text ? $text->present($self) : $text;
            }
            else {
                return '';
            }
        }
        elsif ( !ref $item ) {
            return $item;
        }
        else {
            return '';
        }
    }


    sub view_head1 {
        my ($self, $head1) = @_;

        my $title = $head1->title->present($self);
        my $output = "$title\n" . $head1->content->present($self);

        return $output;
    }


    sub view_head2 {
        my ($self, $head2) = @_;

        my $title = $head2->title->present($self);
        my $output = "$title\n" . $head2->content->present($self);

        return $output;
    }


    sub view_head3 {
        my ($self, $head3) = @_;
        my $title = $head3->title->present($self);
        my $output = "$title\n" . $head3->content->present($self);

        return $output;
    }


    sub view_head4 {
        my ($self, $head4) = @_;
        my $title = $head4->title->present($self);
        my $output = "$title\n" . $head4->content->present($self);
        return $output;
    }

    #------------------------------------------------------------------------
    # view_over($self, $over)
    #
    # Present an =over block - this is a blockquote if there are no =items
    # within the block.
    #------------------------------------------------------------------------

    sub view_over {
        my ($self, $over) = @_;

        if (@{$over->item}) {
            return $over->content->present($self);
        }
        else {
            my $content = $over->content->present($self);
            return $content;
        }
    }

    sub view_item {
        my ($self, $item) = @_;
        my $pad = ' ';
        my $title = $item->title->present($self);
        my $content = $item->content->present($self);
        return "$title\n\n$content";
    }


    sub view_for {
        my ($self, $for) = @_;
        return '' unless $for->format() =~ /\btext\b/;
        return $for->text() . "\n\n";
    }

        
    sub view_begin {
        my ($self, $begin) = @_;
        return '' unless $begin->format() =~ /\btext\b/;
        return $begin->content->present($self);
    }

        
    sub view_textblock {
        my ($self, $text) = @_;
        $text =~ s/\s+/ /mg;
        return $text . "\n\n";
    }


    # <pre>
    sub view_verbatim {
        my ($self, $text) = @_;
        return ''; # ignore
    }


    sub view_seq_bold {
        my ($self, $text) = @_;
        return $text;
    }


    sub view_seq_italic {
        my ($self, $text) = @_;
        return $text;
    }


    # C<>
    sub view_seq_code {
        my ($self, $text) = @_;
        return ''; # Ignore.
    }


    sub view_seq_file {
        my ($self, $text) = @_;
        return '';# Ignore.
    }

    my $entities = {
        gt   => '>',
        lt   => '<',
        amp  => '&',
        quot => '"',
    };

    # E<gt>
    sub view_seq_entity {
        my ($self, $entity) = @_;
        return ''; # Ignore.
    }

    sub view_seq_index {
        return '';
    }

    # L<>
    sub view_seq_link {
        my ($self, $link) = @_;
        return '';
    }
}


1;

