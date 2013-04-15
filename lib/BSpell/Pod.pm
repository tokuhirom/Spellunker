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

    for my $for ($pom->for) {
        if ($for->format eq 'stopwords') {
            $self->{bspell}->add_stopwords(split /\s+/, $for->text);
        }
    }

    my $line = 0;
    my @rv;
    for my $text ( split /[\n\r\f]+/, scalar $pom->content() ) {
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

    local $Pod::POM::DEFAULT_VIEW = 'BSpell::Pod::POM::View::TextBasic';;
    my $parser = Pod::POM->new();
    my $pom = $parser->parse_file($filename)
        or die $parser->error;
    return $self->_check_pom($pom);
}

sub check_text {
    my ($self, $text) = @_;

    local $Pod::POM::DEFAULT_VIEW = 'BSpell::Pod::POM::View::TextBasic';;
    my $parser = Pod::POM->new();
    my $pom = $parser->parse_text($text)
        or die $parser->error;
    return $self->_check_pom($pom);
}

{
    # https://metacpan.org/module/Pod::POM::View::TextBasic
    package BSpell::Pod::POM::View::TextBasic;
    use base 'Pod::POM::View::Text';
    
    our $DROPS = 1;
    
    sub view_seq_bold { return $_[1]; }
    
    sub view_seq_italic { return $_[1]; }
    
    sub view_seq_code { return $DROPS? '' : $_[1] }
    
    sub view_seq_file { return $DROPS? '' : $_[1] }
    
    sub view_seq_link {
        return $DROPS? '' : $_[1];
        my ($self, $link) = @_;
        return ($link =~ m/^(.*?)\|/) ?
        $1 : $link;
    }

    sub view_verbatim { return $DROPS? '' : $_[1] }
}


1;

