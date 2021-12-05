#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;
my $danger_tally = 0;
while (<>) {
    my ($x1, $y1, $x2, $y2) = /(.+),(.+) -> (.+),(.+)/;
    next unless $x1 == $x2 || $y1 == $y2;

    if ($x1 == $x2) {
        ($y1, $y2) = ($y2, $y1) if $y2 < $y1;
        for my $y ($y1 .. $y2) {
            ++$danger_tally if 1 == $grid[$x1][$y]++;
        }
    } elsif ($y1 == $y2) {
        ($x1, $x2) = ($x2, $x1) if $x2 < $x1;
        for my $x ($x1 .. $x2) {
            ++$danger_tally if 1 == $grid[$x][$y1]++;
        }
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
