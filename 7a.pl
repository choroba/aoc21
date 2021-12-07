#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my @crabs = split /,/, <>;
chomp $crabs[-1];

@crabs = sort { $a <=> $b } @crabs;
my $middle = $crabs[ @crabs / 2 ];

my $fuel = sum(map abs($middle - $_), @crabs);
say $fuel;


__DATA__
16,1,2,0,4,2,7,1,2,14
