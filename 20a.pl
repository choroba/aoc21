#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $STEPS = $0 =~ /a/ ? 2 : 50;

chomp( my $algorithm = <> =~ tr/.#/01/r );
<>;
my $space = (sub { 0 }, sub { $_[0] })[substr $algorithm, 0, 1];

sub apply {
    my ($grid, $x, $y, $step) = @_;
    my $nine = "";
    for my $j ($y - 1 .. $y + 1) {
        for my $i ($x - 1 .. $x + 1) {
            if ($i < 0 || $i > $#{ $grid->[0] } || $j < 0 || $j > $#$grid) {
                $nine .=  $space->(1 - $step % 2);
                next
            }
            $nine .= $grid->[$j][$i];
        }
    }
    die unless 9 == length $nine;
    my $dec = oct "0b$nine";
    my $r = substr $algorithm, $dec, 1;
    return $r
}

my @grid;
while (<>) {
    chomp;
    push @grid, map [split //], tr/.#/01/r;
}

my $SIZE = 1;
for my $step (1 .. $STEPS) {
    my @new;
    for my $y (-$SIZE .. $#grid + $SIZE) {
        for my $x (-$SIZE .. $#{ $grid[0] } + $SIZE) {
            $new[$SIZE + $y][$SIZE + $x] = apply(\@grid, $x, $y, $step % 2);
        }
    }
    @grid = @new;
}
my $n = 0;
for my $y (0 .. $#grid) {
    for my $x (0 .. $#{ $grid[0] }) {
        $n += $grid[$y][$x]
    }
}
say $n;

__DATA__
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
