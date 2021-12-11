#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @octopuses;
while (<>) {
    chomp;
    push @octopuses, [split //];
}

my $flash_tally = 0;
my $step = 1;
while (1) {
    my @next;
    my @flashing;
    for my $y (0 .. $#octopuses) {
        for my $x (0 .. $#{ $octopuses[$y] }) {
            $next[$y][$x] = $octopuses[$y][$x] + 1;
            push @flashing, [$y, $x] if $next[$y][$x] > 9;
        }
    }
    while (@flashing) {
        my $f = shift @flashing;
        my ($y, $x) = @$f;
        ++$flash_tally;
        for my $dy (-1 .. 1) {
            my $Y = $y + $dy;
            next if $Y < 0 || $Y > $#next;

            for my $dx (-1 .. 1) {
                next unless $dx || $dy;

                my $X = $x + $dx;
                next if $X < 0 || $X > $#{ $next[$Y] };

                ++$next[$Y][$X];
                push @flashing, [$Y, $X] if 10 == $next[$Y][$X];
            }
        }
    }

    my $simultaneous = 0;
    for my $y (0 .. $#next) {
        for my $x (0 .. $#{ $next[$y] }) {
            ++$simultaneous, $next[$y][$x] = 0 if $next[$y][$x] > 9;
        }
    }

    @octopuses = @next;
    if (@octopuses * @{ $octopuses[0] } == $simultaneous) {
        say $step;
        last
    }
} continue {
    ++$step;
}

__DATA__
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
