#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %ENERGY = (A => 1, B => 10, C => 100, D => 1000);
my %GOAL   = (3 => 'A', 0 => 'B', 1 => 'C', 2 => 'D');  # % 4
my %HOME   = (A => 11, B => 12, C => 13, D => 14);
my %DOWN;
for my $n (11 .. 22) {
    $DOWN{$n} = [grep $_ % 4 == $n % 4, $n + 1 .. 26];
}

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

for my $m (0 .. $#MOVES) {
    my @move = @{ $MOVES[$m] };
    for my $depth (1 .. 3) {
        push @move, $move[-1] + 4;
        push @MOVES, [@move];
    }
}

for my $from (11 .. 14) {
    for my $to (0, 1, 3, 5, 7, 9, 10) {
        my $up = 2 * ($from - 10);
        my @move = ($up < $to ? $up .. $to : reverse $to .. $up);
        for my $depth (0 .. 3) {
            unshift @move, 4 * $depth + $from;
            push @MOVES, [@move];
        }
    }
}

my $init = "";
while (<>) {
    chomp;
    $init .= join "", grep /[\.ABCD]/, split //;
}

substr $init, -4, 0, 'DCBADBAC';

{   package Day23;

    use parent 'AI::Pathfinding::AStar';

    my %h2h;

    sub new {
        bless {}, shift
    }

    sub getSurrounding {
        my ($self, $c, $t) = @_;
        my @surr;
        for my $i (0 .. length($c) - 1) {
            my $amphipod = substr $c, $i, 1;
            next if $amphipod eq '.';

            for my $move (grep $_->[0] == $i, @MOVES) {
                next if grep $_ ne '.',
                        map substr($c, $_, 1),
                        @$move[1 .. $#$move];

                if ($move->[-1] >= 11) {
                    next if $GOAL{ $move->[-1] % 4 } ne $amphipod;

                    my @down = @{ $DOWN{ $move->[-1] } // [] };
                    next if @down
                         && grep $_ ne '.' && $_ ne $amphipod,
                            map substr($c, $_, 1), @down;
                }

                my $d = $c;
                substr $d, $i, 1, '.';
                substr $d, $move->[-1], 1, $amphipod;
                my $f = $#$move * $ENERGY{$amphipod};

                my $h = 0;
                for my $j (0 .. length($d) - 1) {
                    my $amph = substr $d, $j, 1;
                    next if '.' eq $amph;

                    my ($m) = grep $_->[0] == $j && $_->[-1] == $HOME{$amph},
                              @MOVES;
                    if (!$m) {
                        if ($j % 4 == $HOME{$amph} % 4) {
                            $m = [undef];
                        } elsif (exists $h2h{$j} && exists $h2h{$j}{ $HOME{$amph} }) {
                            $m = $h2h{$j}{ $HOME{$amph} };
                        } else {
                            my @jup = ($j);
                            push @jup, $jup[-1] - 4 until $jup[-1] < 15;

                            my $jup = 2 * ($jup[-1] - 10);
                            my $hup = 2 * ($HOME{$amph} - 10);
                            push @jup, $hup < $jup
                                ? $hup .. $jup
                                : reverse $jup .. $hup;
                            push @jup, $HOME{$amph};
                            $m = $h2h{$j}{ $HOME{$amph} } = [@jup];
                        }
                    }

                    $h += $#$m * $ENERGY{$amph};
                }
                push @surr, [$d, $f, $h];
            }
        }
        return \@surr
    }
}

my $map = 'Day23'->new;
my $path = $map->findPath($init, '.' x 11 . 'ABCD' x 4);
use Data::Dumper; print Dumper $path;

my $p = 0;
for my $i (1 .. $#$path) {
    my ($from, $to);
    for my $j (0 .. 26) {
        my $ch2 = substr $path->[$i], $j, 1;
        my $ch1 = substr $path->[$i - 1], $j, 1;
        if ($ch1 ne $ch2) {
            ($ch2 eq '.' ? $from : $to) = $j;
        }
    }
    my ($m) = grep $_->[0] == $from && $_->[-1] == $to, @MOVES;
    $m //= [undef];
    $p += $#$m * $ENERGY{ substr $path->[$i], $to, 1 };
}
say $p;

# # # # # # # # # # # # #
# 0 1 2 3 4 5 6 7 8 910 #
# # # 11# 12# 13# 14# # #
    # 15# 16# 17# 18#
    # 19# 20# 21# 22#
    # 23# 24# 25# 26#
    #################

__DATA__
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
