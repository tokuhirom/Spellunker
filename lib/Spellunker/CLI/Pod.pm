package Spellunker::CLI::Pod;
use strict;
use warnings;
use utf8;
use Getopt::Long;
use Spellunker::Pod;

use version; our $VERSION = version->declare("v0.0.4");

sub new {
    my $class = shift;
    bless {}, $class;
}

sub run {
    my $self = shift;

    my $p = Getopt::Long::Parser->new(
        config => [qw(posix_default no_ignore_case auto_help)]
    );
    $p->getoptions(
        'v|version' => \my $show_version
    );
    if ($show_version) {
        print "spellunker-pod: $VERSION\n";
        exit 0;
    }

    if (@ARGV) {
        my $fail = 0;
        for my $filename (@ARGV) {
            my $spellunker = Spellunker::Pod->new();
            my @err = $spellunker->check_file($filename);
            for (@err) {
                my $lineno = shift @$_;
                for (@$_) {
                    print "$filename: $lineno: $_\n";
                }
            }
            $fail++ if @err;
        }
        exit $fail;
    } else {
        my $content = join('', <>);
        my $spellunker = Spellunker::Pod->new();
        my @err = $spellunker->check_text($content);
        for (@err) {
            my $lineno = shift @$_;
            for (@$_) {
                print "$lineno: $_\n";
            }
        }
        exit @err ? 1 : 0;
    }
}

1;

