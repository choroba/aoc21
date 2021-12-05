#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;
my $danger_tally = 0;
while (<>) {
    my ($x1, $y1, $x2, $y2) = /(.+),(.+) -> (.+),(.+)/;
    my $xstep = $x2 <=> $x1;
    my $ystep = $y2 <=> $y1;

    my ($x, $y) = ($x1, $y1);
    while (1) {
        ++$danger_tally if 1 == $grid[$x][$y]++;
        last if $x == $x2 && $y == $y2;

        $x += $xstep;
        $y += $ystep;
    }
}
say $danger_tally;

__DATA__
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
