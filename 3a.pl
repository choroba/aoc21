#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };
use Syntax::Construct qw{ /r };

use ARGV::OrDATA;

my @bit_frequency;
while (<>) {
    chomp;
    my $i = 0;
    ++$bit_frequency[$i++][$_] for split //;
}
my $gamma = join "", map $_->[0] > $_->[1] ? 0 : 1, @bit_frequency;
my $epsilon = $gamma =~ tr/01/10/r;
say oct("0b$gamma") * oct("0b$epsilon");

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
