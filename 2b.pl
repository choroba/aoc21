#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my ($aim, $depth, $horiz) = (0, 0, 0);
while (<>) {
    my ($direction, $amount) = split;
    {
        forward => sub { $horiz += $amount; $depth += $amount * $aim },
        up      => sub { $aim -= $amount },
        down    => sub { $aim += $amount }
    }->{$direction}();
}
say $depth * $horiz;

__DATA__
forward 5
down 5
forward 8
up 3
down 8
forward 2
