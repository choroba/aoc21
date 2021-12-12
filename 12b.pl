#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %caves;
while (<>) {
    chomp;
    my ($from, $to) = split /-/;
    undef $caves{$from}{$to};
    undef $caves{$to}{$from};
}

my @paths = (['start']);
while (my @extendable = grep $paths[$_]->[-1] ne 'end', 0 .. $#paths) {
    for my $ie (reverse @extendable) {
        my $e = splice @paths, $ie, 1;
        for my $next (keys %{ $caves{ $e->[-1] } }) {
            my @new = (@$e, $next);
            if ($next =~ /^[[:upper:]]/o) {
                push @paths, \@new;
            } else {
                my %freq;
                ++$freq{$_} for @new;
                my $ok = 2;
                for my $cave (keys %freq) {
                    if ($cave =~ /^[[:lower:]]/o && $freq{$cave} > 1) {
                        --$ok;
                        $ok = 0 if $freq{$cave} > 2 
                                || grep $_ eq $cave, 'start', 'end';
                    }
                }
                push @paths, \@new if $ok > 0;
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
