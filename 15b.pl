#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @cave;
while (<>) {
    chomp;
    push @cave, [map [$_], split //];
}
my ($smallx, $smally) = ($#cave, $#{ $cave[-1] });

for my $tilex (0 .. 4) {
    for my $tiley (0 .. 4) {
        next unless $tilex || $tiley;
        for my $x (0 .. $smallx) {
            for my $y (0 .. $smally) {
                $cave[$tilex * (1 + $smallx) + $x][$tiley * (1 + $smally) + $y]
                    = [(($cave[$x][$y][0] + $tilex + $tiley) % 9 ) || 9]
            }
        }
    }
}

$cave[0][0][1] = 0;
my @agenda = ([0, 0]);
my ($endx, $endy) = ($#cave, $#{ $cave[-1] });

while (@agenda) {
    my ($x, $y) = @{ shift @agenda };
    for my $move ([0, 1], [1, 0], [0, -1], [-1, 0]) {
        my ($X, $Y) = ($x + $move->[0], $y + $move->[1]);
        next if $X < 0 || $X > $#cave
             || $Y < 0 || $Y > $#{ $cave[$X] };

        my $risk = $cave[$x][$y][1] + $cave[$X][$Y][0];
        $cave[$X][$Y][1] = $risk, push @agenda, [$X, $Y]
            if ! defined $cave[$X][$Y][1]
            || $risk < $cave[$X][$Y][1];
    }
}

say $cave[$endx][$endy][1];

__DATA__
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
