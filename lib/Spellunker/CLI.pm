package Spellunker::CLI;
use strict;
use warnings;
use utf8;

use Spellunker;

use Regexp::Common qw /URI/;

# Ref http://www.din.or.jp/~ohzaki/mail_regex.htm#Simplify
my $mail_regex = (
    q{(?:[-!#-'*+/-9=?A-Z^-~]+(?:\.[-!#-'*+/-9=?A-Z^-~]+)*|"(?:[!#-\[\]-} .
    q{~]|\\\\[\x09 -~])*")@[-!#-'*+/-9=?A-Z^-~]+(?:\.[-!#-'*+/-9=?A-Z^-~]+} .
    q{)*}
);


sub new {
    my $class = shift;
    bless {}, $class;
}

sub run {
    my $self = shift;

    my $engine = Spellunker->new();
    while (<>) {
        my @words = $engine->check_line($_);
        print "Bad: $_ at line $.\n" for @words;
    }
}

1;

