#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $d = 1;
my $rolls = 0;
sub roll {
    ++$rolls;
    return $d++ % 100 || 100
}

my @pos;
while (<>) {
    chomp;
    push @pos, /: (\d+)/;
}

my @scores = (0, 0);
my $player = 0;
while ($scores[0] < 1000 && $scores[1] < 1000) {
    my $roll = roll() + roll() + roll();
    $pos[$player] += $roll;
    $pos[$player] %= 10;
    $pos[$player] ||= 10;
    $scores[$player] += $pos[$player];
    ++$player;
    $player %= 2;
}
my $loser = (grep $_ < 1000, @scores)[0];
say $loser * $rolls;

__DATA__
Player 1 starting position: 4
Player 2 starting position: 8
