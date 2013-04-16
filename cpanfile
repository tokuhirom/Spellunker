requires 'Regexp::Common';
requires 'Pod::Simple';
requires 'File::ShareDir';
requires 'Getopt::Long';
requires 'Pod::Simple::Methody';
requires 'Test::Builder';
requires 'parent';
requires 'version';

on test => sub {
    requires 'Test::More', 0.98;
};

on configure => sub {
};

on 'develop' => sub {
};

