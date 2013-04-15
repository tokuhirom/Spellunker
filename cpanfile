requires 'Regexp::Common';
requires 'Pod::POM';

on test => sub {
    requires 'Test::More', 0.98;
};

on configure => sub {
};

on 'develop' => sub {
};

