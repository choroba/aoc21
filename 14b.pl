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

my %pairs;
++$pairs{"$1$2"} while $template =~ /(.)(?=(.))/g;
for my $step (1 .. 40) {
    my %next;
    for my $pair (keys %pairs) {
        my $quantity = delete $pairs{$pair};
        my $i = $insert{$pair};
        my @ch = split //, $pair;
        $next{$_} += $quantity for "$ch[0]$i", "$i$ch[1]";
    }
    %pairs = %next;
}

my %quantities;
for my $pair (keys %pairs) {
    $quantities{$_} += $pairs{$pair} for split //, $pair;
}
$_ = int(0.5 + $_ / 2) for values %quantities;
my @sorted = sort { $a <=> $b } values %quantities;
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
