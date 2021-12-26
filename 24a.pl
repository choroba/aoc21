#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

{   package MONAD;
    use Moo;
    has [qw[ w x y z ]] => (is => 'rw', default => 0);
    has input => (is => 'rw', default => sub { [] });

    sub val {
        return $_[1] if $_[1] =~ tr/0-9//;
        return $_[0]->${ \"$_[1]" }
    }

    sub set {
        $_[0]->${\"$_[1]"}($_[0]->val($_[2]))
    }

    my %dispatch = (
        inp => sub { $_[0]->set($_[1], shift @{ $_[0]->input }) },
        add => sub { $_[0]->set($_[1], $_[0]->val($_[1]) + $_[0]->val($_[2])) },
        mul => sub { $_[0]->set($_[1], $_[0]->val($_[1]) * $_[0]->val($_[2])) },
        mod => sub { $_[0]->set($_[1], $_[0]->val($_[1]) % $_[0]->val($_[2])) },
        div => sub { $_[0]->set($_[1], int($_[0]->val($_[1]) / $_[0]->val($_[2]))) },
        eql => sub { $_[0]->set($_[1], ($_[0]->val($_[1]) == $_[0]->val($_[2])) ? 1 : 0) },
    );

    sub execute {
        my $cmd = $dispatch{ $_[1] };
        $_[0]->$cmd($_[2], $_[3])
    }
}

my @prog = <>;

my @results;

my $input = '9' x 7;
my $step = -1;
while (@results != 2) {
    next if $input =~ /0/;

    my @inputs = split //, $input;
    splice @inputs, 4, 0, $inputs[3];

    splice @inputs, 6, 0, $inputs[5] + 1;
    next if 10 == $inputs[6];

    splice @inputs, 8, 0, $inputs[7] + 2;
    next if $inputs[8] > 9;

    splice @inputs, 9, 0, $inputs[2] + 7;
    next if $inputs[9] > 9;

    splice @inputs, 11, 0, $inputs[10] - 1;
    next if $inputs[11] < 1;

    splice @inputs, 12, 0, $inputs[1] + 4;
    next if $inputs[12] > 9;

    splice @inputs, 13, 0, $inputs[0] - 2;
    next if $inputs[13] < 1;

    my $m = 'MONAD'->new(input => [@inputs]);
    for (@prog) {
        my ($op, $var, $val) = split;
        $m->execute($op, $var, $val);
    }
    if (0 == $m->z) {
        push @results, join "", @inputs;
        $input = '1' x 7;
        $step = 1;
    }
} continue {
    $input += $step;
}
say for @results;

__DATA__
inp x
mul x -1

inp z
inp x
mul z 3
eql z x

inp w
add z w
mod z 2
div w 2
add y w
mod y 2
div w 2
add x w
mod x 2
div w 2
mod w 2
