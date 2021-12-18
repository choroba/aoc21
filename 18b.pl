#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

sub add {
    reduce("[$_[0],$_[1]]")
}

my %depth_change = ('[' => 1, ']' => -1);
sub reduce {
    my ($f) = @_;
    my $change = 1;
  CHANGE:
    while ($change) {
        undef $change;
        my $depth = 0;
        for my $pos (0 .. length($f) - 1) {
            $depth += $depth_change{ substr $f, $pos, 1 } // 0;
            if ($depth > 4) {
                $change = 1;
                my ($x, $y) = substr($f, $pos) =~ /\[(\d+),(\d+)\]/;
                my $length = 3 + length("$x$y");
                my $before = substr $f, 0, $pos;
                my $after  = substr $f, $pos + $length;

                if (my ($right) = $after =~ /(\d+)/) {
                    my $ny = $y + $right;
                    $after =~ s/$right/$ny/;
                }

                if (my ($left) = $before =~ /.*\D(\d+)/) {
                    my $nx = $x + $left;
                    $before =~ s/.*\D*\K$left/$nx/;
                }
                $f = "${before}0$after";
                next CHANGE
            }
        }
        for my $pos (0 .. length($f) - 1) {
            if (my ($x) = substr($f, $pos) =~ /^(\d{2,})/) {
                $change = 1;
                my $down = int($x / 2);
                my $up = $down + $x % 2;
                $f =~ s/$x/[$down,$up]/;
                next CHANGE
            }
        }
    }
    return $f
}

sub magnitude {
    my ($sf) = @_;
    $sf =~ s/\[(\d+),(\d+)\]/3 * $1 + 2 * $2/ge while $sf =~ /\D/;
    return $sf
}

chomp( my @numbers = <> );
my $max = 0;
for my $i (0 .. $#numbers) {
    for my $j (0 .. $#numbers) {
        my $r = magnitude(add($numbers[$i], $numbers[$j]));
        $max = $r if $r > $max;
    }
}

say $max;

__DATA__
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
