#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %ENERGY = (A => 1, B => 10, C => 100, D => 1000);
my %GOAL   = (11 => 'A', 12 => 'B', 13 => 'C', 14 => 'D',
              15 => 'A', 16 => 'B', 17 => 'C', 18 => 'D');

my @MOVES;
push @MOVES, map { [0 .. $_, 10 + $_ / 2],
                   [reverse($_ .. 10), 10 + $_ / 2]
             } 2, 4, 6, 8;
push @MOVES, map [@$_[1 .. $#$_]], @MOVES;

for my $from (3, 5, 7) {
    for my $to (2, 4, 6, 8) {
        my @s = $from < $to ? $from .. $to : reverse $to .. $from;
        push @s, $to / 2 + 10;
        push @MOVES, \@s;
    }
}

push @MOVES, map [@$_, $_->[-1] + 4], @MOVES;
for my $from (11 .. 14) {
    for my $to (0, 1, 3, 5, 7, 9, 10) {
        my $up = 2 * ($from - 10);
        my @move = ($from, $up < $to ? $up .. $to : reverse $to .. $up);
        push @MOVES, [@move], [4 + $from, @move];
    }
}

my $init = "";
while (<>) {
    chomp;
    $init .= join "", grep /[\.ABCD]/, split //;
}

my %state  = ($init => 0);
my %agenda = ($init => 0);
while (keys %agenda) {
    my %next;
    for my $c (keys %agenda) {
        for my $i (0 .. length($c) - 1) {
            my $amphipod = substr $c, $i, 1;
            next if $amphipod =~ /[\d.]/;

            for my $move (grep $_->[0] == $i, @MOVES) {
                next if grep $_ ne '.',
                        map substr($c, $_, 1),
                        @$move[1 .. $#$move];

                if ($move->[-1] >= 11) {
                    next if $GOAL{ $move->[-1] } ne uc $amphipod;
                    next if $move->[-1] < 15
                         && uc $amphipod ne uc substr $c, $move->[-1] + 4, 1;
                }

                my $d = $c;
                substr $d, $i, 1, '.';
                substr $d, $move->[-1], 1, lc $amphipod;
                my $e = $state{$c} + $#$move * $ENERGY{uc $amphipod};
                next if ($state{$d} // $e) < $e;

                undef $next{$d};
                $state{$d} = $e;
            }
        }
    }
    %agenda = %next;
}
say "$_: $state{$_}" for grep /^[.]{11}/, keys %state;


# # # # # # # # # # # # #
# 0 1 2 3 4 5 6 7 8 910 #
# # # 11# 12# 13# 14# # #
    # 15# 16# 17# 18#
    #################
__DATA__
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
