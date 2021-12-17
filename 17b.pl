#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $line = <>;
my ($x0, $x1, $y0, $y1) = $line =~ /x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/;
my %hit;
for my $xd0 (-350 .. 350) {
    for my $yd0 (-350 .. 350) {
        my ($xd, $yd) = ($xd0, $yd0);
        my ($x, $y) = (0, 0);

        my $step = 0;
        my $pd;
        while (1) {
            $x += $xd;
            $y += $yd;
            my $d = abs($x - $x1) * abs($y - $y1);

            if ($x >= $x0 && $x <= $x1 && $y >= $y0 && $y <= $y1) {
                undef $hit{"$xd0 $yd0"};
            } elsif ($y < $y0 && $yd < 0) {
                last
            }

            $xd += 0 <=> $xd;
            --$yd;
            ++$step;
            $pd = $d;
        }
    }
}
say scalar keys %hit;

__DATA__
target area: x=20..30, y=-10..-5
