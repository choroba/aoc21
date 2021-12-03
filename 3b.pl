#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

sub process {
    my ($list, $gt) = @_;
    my $pos = 0;
    while (@$list > 1) {
        my $count1 = grep substr($_, $pos, 1), @$list;
        my $cmp = $gt ? $count1 >= @$list / 2
                      : $count1 <= @$list / 2;
        @$list = grep substr($_, $pos, 1) == $cmp, @$list;
        ++$pos;
    }
    return $list->[0]
}


chomp( my @oxygen = <> );
my @co2 = @oxygen;
tr/01/10/ for @co2;

my $oxygen = process(\@oxygen, 1);
my $co2    = process(\@co2,    0);
$co2 =~ tr/01/10/;
say oct("0b$oxygen") * oct("0b$co2");

__DATA__
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
