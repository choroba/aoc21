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
            push @paths, [@$e, $next]
                unless $next =~ /^[[:lower:]]/o
                && grep $_ eq $next, @$e;
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
