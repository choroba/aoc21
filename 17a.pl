#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $line = <>;
my ($x0, $x1, $y0, $y1) = $line =~ /x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/;
my $MAXY = 0;
for (1 .. 100_000) {
    my ($xd, $yd) = map int rand 100, 1, 2;
    my ($xd0, $yd0) = ($xd, $yd);
    my ($x, $y) = (0, 0);

    my $step = 0;
    my $maxy = 0;
    while (1) {
        $x += $xd;
        $y += $yd;
        $maxy = $y if $y > $maxy;
        if ($x >= $x0 && $x <= $x1 && $y >= $y0 && $y <= $y1) {
            $MAXY = $maxy if $maxy >= $MAXY;
        }
        $xd += 0 <=> $xd;
        --$yd;
        ++$step;
        last if $step > 500;
    }
}
say $MAXY;

__DATA__
target area: x=20..30, y=-10..-5
