#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant MAX => 4;

my @numbers = split /,/, <>;
chomp($numbers[-1]);

my @boards;
my %where;
my %win;

sub mark {
    my ($n) = @_;
    for my $w (keys %{ $where{$n} }) {
        my ($board, $y, $x) = split ' ', $w;
        ++$where{$n}{$w};
        ++$boards[$board][$y][$x][1];
    }
}

sub check {
    my ($n) = @_;
    my @win;
    for my $board (0 .. $#boards) {
        for my $row (0 .. MAX) {
            push @win, $board if 1 + MAX == grep $_->[1], @{ $boards[$board][$row] };
        }
        for my $col (0 .. MAX) {
            push @win, $board if 1 + MAX == grep $_->[$col][1], @{ $boards[$board] }
        }
    }
    return @win
}

sub win {
    my ($n, $board) = @_;
    my $sum = 0;
    $sum += $_->[0] for grep ! $_->[1], map @$_, @{ $boards[$board] };
    return $sum * $n
}

while (<>) {
    chomp;
    if ("" eq $_) {
        push @boards, [];
    } else {
        push @{ $boards[-1] }, [map [$_, 0], split];
        for my $i (0 .. MAX) {
            my $board = $#boards;
            my $y = $#{ $boards[-1] };
            my $n = $boards[-1][-1][$i][0];
            undef $where{$n}{"$board $y $i"};
        }
    }
}

for my $n (@numbers) {
    mark($n);
    my %uniq;
    @uniq{ check($n) } = ();
    my @win = keys %uniq;
    ++$win{$_} for @win;
    if (@boards == keys %win) {
        for my $board (@win) {
            if (1 == $win{$board}) {
                say win($n, $board);
                exit
            }

        }
        die;
    }
}

__DATA__
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
