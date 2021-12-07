#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my @crabs = split /,/, <>;
chomp $crabs[-1];

@crabs = sort { $a <=> $b } @crabs;
my $consumption = sub {
    sum(map abs($_[0] - $_) * (abs($_[0] - $_) + 1) / 2, @crabs) };

my @best = (0, $consumption->(0));

for my $ci (0 .. $#crabs) {
    my $c = $crabs[$ci];
    my $fuel = $consumption->($c);
    @best = ($c, $fuel, $ci) if $fuel < $best[1];
}

my $from = my $to = $best[-1];
--$from while $from >= 0     && $crabs[$from] == $best[0];
++$to   while $to <= $#crabs && $crabs[$to]   == $best[0];

for my $c ($crabs[$from] .. $crabs[$to]) {
    my $fuel = $consumption->($c);
    @best = ($c, $fuel) if $fuel < $best[1];
}

say $best[1];

__DATA__
16,1,2,0,4,2,7,1,2,14
