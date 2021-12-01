#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;


my $tally = 0;
my @window = map scalar <>, 1 .. 3;
my $sum = $window[0] + $window[1] + $window[2];
while (<>) {
    my $newsum = $_ + $sum - shift @window;
    ++$tally if $newsum > $sum;
    $sum = $newsum;
    push @window, $_;
}
say $tally;

__DATA__
199
200
208
210
200
207
240
269
260
263
