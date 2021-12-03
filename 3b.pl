#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my @list = <> );
my @oxygen = my @co2 = @list;

my $pos = 0;
while (@oxygen > 1) {
    my $count1 = grep substr($_, $pos, 1), @oxygen;
    @oxygen = grep substr($_, $pos, 1) == ($count1 >= @oxygen / 2), @oxygen;
    ++$pos;
}
$pos = 0;
while (@co2 > 1) {
    my $count0 = grep ! substr($_, $pos, 1), @co2;
    @co2 = grep substr($_, $pos, 1) != ($count0 <= @co2 / 2), @co2;
    ++$pos;
}
say oct("0b$oxygen[0]") * oct("0b$co2[0]");

__DATA__
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
