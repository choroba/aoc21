#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @pos;
while (<>) {
    chomp;
    push @pos, /: (\d+)/;
}

my %outcomes;
for my $roll1 (1 .. 3) {
    for my $roll2 (1 .. 3) {
        for my $roll3 (1 .. 3) {
            ++$outcomes{$roll1 + $roll2 + $roll3};
        }
    }
}

my %universe = ("@pos 0 0" => 1);
my $change = 1;
my $player = 0;
my @score;
my @wins = (0, 0);
while (keys %universe) {
    my %next;
    for my $u (keys %universe) {
        my $count = $universe{$u};
        ($pos[0], $pos[1], $score[0], $score[1]) = split ' ', $u;

        for my $outcome (keys %outcomes) {
            my @p = @pos;
            my @s = @score;
            $p[$player] += $outcome;
            $p[$player] %= 10;
            $p[$player] ||= 10;
            $s[$player] += $p[$player];
            if ($s[$player] >= 21) {
                $wins[$player] += $count * $outcomes{$outcome};
            } else {
                $next{"@p @s"} += $count * $outcomes{$outcome};
            }
        }
    }
    ++$player;
    $player %= 2;
    %universe = %next;
}
say $wins[ $wins[1] > $wins[0] ];

__DATA__
Player 1 starting position: 4
Player 2 starting position: 8
