#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ uniq };  # For visualisation only.

sub basin {
    my ($heightmap, $basin_tally, $x, $y, $basin) = @_;
    $basin->[$y][$x] = $basin_tally;
    for my $move ([0, 1], [1, 0], [0, -1], [-1, 0]) {
        my $X = $x + $move->[0];
        my $Y = $y + $move->[1];
        next if $X < 0
             || $Y < 0
             || $Y > $#$heightmap
             || $X > $#{ $heightmap->[$Y] }
             || 9 == $heightmap->[$Y][$X]
             || defined $basin->[$Y][$X];

        basin($heightmap, $basin_tally, $X, $Y, $basin);
    }
}

my @heightmap;
while (<>) {
    chomp;
    push @heightmap, [split //];
}

my @basin;
my $basin_tally = 0;
for my $y (0 .. $#heightmap) {
    for my $x (0 .. $#{ $heightmap[$y] }) {
        my $current =  $heightmap[$y][$x];
        next if $current == 9
            || $y > 0                    && $current >= $heightmap[$y - 1][$x]
            || $y < $#heightmap          && $current >= $heightmap[$y + 1][$x]
            || $x > 0                    && $current >= $heightmap[$y][$x - 1]
            || $x < $#{ $heightmap[$y] } && $current >= $heightmap[$y][$x + 1];

        basin(\@heightmap, $basin_tally++, $x, $y, \@basin);
    }
}

my %size = ("" => -1);
for my $y (0 .. $#heightmap) {
    for my $x (0 .. $#{ $heightmap[$y] }) {
        next unless defined $basin[$y][$x];

        ++$size{ $basin[$y][$x] };
    }
}

### Visualise.

# my %char;
# my $s = 0;
# for my $size (sort { $a <=> $b } uniq(values %size)) {
#     $char{$size} = chr(32 + $s++);
# }

# for my $y (0 .. $#heightmap) {
#     for my $x (0 .. $#{ $heightmap[$y] }) {
#         print $char{ $size{ $basin[$y][$x] // "" } };
#     }
#     print "\n";
# }

my @largest3 = (sort { $a <=> $b } values %size)[-3 .. -1];
say $largest3[0] * $largest3[1] * $largest3[2];

__DATA__
2199943210
3987894921
9856789892
8767896789
9899965678
