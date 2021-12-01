#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;


my $p = -INF;
my $tally = -1;
while (<>) {
    ++$tally if $_ > $p;
    $p = $_
}
say $tally < 0 ? 0 : $tally

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
