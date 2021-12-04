#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

use constant MAX => 4;

my @numbers;
my @boards;
my %where;

sub mark {
    my ($n) = @_;
    for my $w (keys %{ $where{$n} }) {
        my ($board, $y, $x) = split ' ', $w;
        delete $boards[$board]{nums}{$n};
        return $board unless --$boards[$board]{cols}{$x};
        return $board unless --$boards[$board]{rows}{$y};
    }
    return
}

sub score {
    my ($n, $board) = @_;
    return sum(keys %{ $boards[$board]{nums} }) * $n
}

@numbers = split /,/, <>;
chomp($numbers[-1]);

while (<>) {
    chomp;
    if ("" eq $_) {
        push @boards, {};
    } else {
        my @ns = split;
        for my $i (0 .. MAX) {
            my $board = $#boards;
            my $y = int(keys(%{ $boards[-1]{nums} }) / (1 + MAX));
            my $n = $ns[$i];
            undef $where{$n}{"$board $y $i"};
            ++$boards[$board]{cols}{$i};
            ++$boards[$board]{rows}{$y};
            undef $boards[$board]{nums}{$n};
        }
    }
}

for my $n (@numbers) {
    my $win = mark($n);
    next unless defined $win;

    my $score = score($n, $win);
    say $score;
    last
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
