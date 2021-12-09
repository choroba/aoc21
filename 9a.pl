#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @heightmap;
while (<>) {
    chomp;
    push @heightmap, [split //];
}

my $risk_level = 0;
for my $y (0 .. $#heightmap) {
    for my $x (0 .. $#{ $heightmap[$y] }) {
        my $current =  $heightmap[$y][$x];
        next if $current == 9
            || $y > 0                    && $current >= $heightmap[$y - 1][$x]
            || $y < $#heightmap          && $current >= $heightmap[$y + 1][$x]
            || $x > 0                    && $current >= $heightmap[$y][$x - 1]
            || $x < $#{ $heightmap[$y] } && $current >= $heightmap[$y][$x + 1];

        $risk_level += $heightmap[$y][$x] + 1;
    }
}
say $risk_level;

__DATA__
2199943210
3987894921
9856789892
8767896789
9899965678
