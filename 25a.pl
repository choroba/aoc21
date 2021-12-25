#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;
while (<>) {
    chomp;
    push @grid, [split //];
}

my @move = ('>', 'v');
my %direction = ('>' => [0, 1], 'v' => [1, 0]);

my $change = 1;
my $step = 1;
my $face_i = 0;
while (1) {
    undef $change if 0 == $face_i;
    my $face = $move[$face_i];
    my @next;
    for my $y (0 .. $#grid) {
        for my $x (0 .. $#{ $grid[$y] }) {
            if ($face eq ($grid[$y][$x] // "")) {
                my @neighbour = (($y + $direction{$face}[0]) % @grid,
                                 ($x + $direction{$face}[1]) % @{ $grid[$y] });
                if ($grid[ $neighbour[0] ][ $neighbour[1] ] eq '.') {
                    $change = 1;
                    $next[ $neighbour[0] ][ $neighbour[1] ] = $face;
                    $next[$y][$x] //= '.';
                } else {
                    $next[$y][$x] = $face;
                }
            } else {
                $next[$y][$x] = $grid[$y][$x] unless $next[$y][$x];
            }
        }
    }
    ++$step;
    @grid = @next;
    last if $face_i && ! $change;
    $face_i = ($face_i + 1) % 2;
}
say int($step / 2);
__DATA__
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
