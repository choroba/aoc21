#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

{   package Paper::Transparent;
    use Moo;
    has grid => (is => 'rw', default => sub { {} });

    sub delete { delete $_[0]->grid->{ "$_[1],$_[2]" } }
    sub dots   { keys %{ $_[0]->grid } }

    sub show {
        my ($self) = @_;
        my ($max_x, $max_y) = (0, 0);
        my @grid;
        for my $d ($self->dots) {
            my ($x, $y) = split /,/, $d;
            $max_x = $x if $x > $max_x;
            $max_y = $y if $y > $max_y;
            $grid[$y][$x] = 1;
        }
        for my $y (0 .. $max_y) {
            for my $x (0 .. $max_x) {
                print $grid[$y][$x] ? '#' : '.';
            }
            print "\n";
        }
    }

    sub add {
        my ($self, @coord) = @_;
        $coord[0] = join ',', @coord if 2 == @coord;
        undef  $_[0]->grid->{ $coord[0] };
    }

    sub fold {
        my ($self, $axis, $coord) = @_;
        for my $dot ($self->dots) {
            my ($x, $y) = split /,/, $dot;
            if ($axis eq 'y' && $y > $coord) {
                $self->delete($x, $y);
                $self->add($x, 2 * $coord - $y);
            } elsif ($axis eq 'x' && $x > $coord) {
                $self->delete($x, $y);
                $self->add(2 * $coord - $x, $y);
            }
        }
    }
}

my $paper = 'Paper::Transparent'->new;
while (<>) {
    chomp;
    last unless length;

    $paper->add($_);
}

while (<>) {
    my ($axis, $coord) = /fold along ([xy])=(\d+)/;
    $paper->fold($axis, $coord);
}
$paper->show;


__DATA__
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
