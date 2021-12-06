#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

use constant DAYS => 256;

my @init = split /,/, <>;
chomp $init[-1];
my %fish;
++$fish{$_} for @init;

for (1 .. DAYS) {
    my %next;
    for my $d (keys %fish) {
        if ($d > 0) {
            $next{$d - 1} += $fish{$d};
        } else {
            $next{8} += $fish{$d};
            $next{6} += $fish{$d};
        }
    }
    %fish = %next;
}

say sum(values %fish);

__DATA__
3,4,3,1,2
