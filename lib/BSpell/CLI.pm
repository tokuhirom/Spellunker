package BSpell::CLI;
use strict;
use warnings;
use utf8;

use BSpell;

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

    my $engine = BSpell->new();
    while (<>) {
        # Remove E-mail address.
        s!<$mail_regex>|$mail_regex!!;

        # Remove HTTP URI
        s!$RE{URI}{HTTP}!!g;

        # Copyright mark
        s!\(C\)!!gi;

        for ( grep /\S/, split /[\/`"><': \t,.()?;!-]+/, $_) {
            next if /^[0-9]+$/;

            s/\n//;
            $engine->is_good_word($_)
                or print "Bad: $_ at line $.\n";
        }
    }
}

1;

