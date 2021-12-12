#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use constant DUPLICATE => 1;

use ARGV::OrDATA;

my %caves;
while (<>) {
    chomp;
    my ($from, $to) = split /-/;
    undef $caves{$from}{$to};
    undef $caves{$to}{$from};
}

my @paths = ([['start'], 0]);
while (my @extendable = grep $paths[$_][0]->[-1] ne 'end', 0 .. $#paths) {
    for my $ie (reverse @extendable) {
        my $e = splice @paths, $ie, 1;
        for my $next (keys %{ $caves{ $e->[0][-1] } }) {
            next if $next eq 'start';

            my @new = (@{ $e->[0] }, $next);
            if ($next =~ /^[[:upper:]]/o) {
                push @paths, [\@new, $e->[DUPLICATE]];

            } elsif ($e->[DUPLICATE]) {
                push @paths, [\@new, 1]
                    unless grep $next eq $_, @{ $e->[0] };

            } else {
                push @paths, [\@new, 0+!! grep $next eq $_, @{ $e->[0] }];
            }
        }
    }
}
say scalar @paths;

__END__
start-A
start-b
A-c
A-b
b-d
A-end
b-end
