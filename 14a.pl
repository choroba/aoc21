#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my $template = <> );
<>;

my %insert;
while (<>) {
    chomp;
    my ($from, $to) = split / -> /;
    $insert{$from} = $to;
}

for my $step (1 .. 10) {
    for my $pos (reverse 0 .. length($template) - 2) {
        substr $template, $pos + 1, 0, $insert{ substr $template, $pos, 2 };
    }
}
my %quantity;
++$quantity{$_} for split //, $template;
my @sorted = sort { $a <=> $b } values %quantity;
say $sorted[-1] - $sorted[0];

__DATA__
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
