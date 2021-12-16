#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %TYPE = (4 => 'LITERAL');
sub packet {
    my ($bin) = @_;
    my %packet = (sum => 0);
    $packet{version} = (unpack 'C', pack 'B3', substr $bin, 0, 3, "") >> 5;
    $packet{type}    = (unpack 'C', pack 'B3', substr $bin, 0, 3, "") >> 5;
    if ('LITERAL' eq ($TYPE{ $packet{type} } // "")) {
        my @groups;
        while (1) {
            push @groups, substr $bin, 0, 5, "";
            last if 0 == index $groups[-1], '0';
        }
        {   no warnings 'portable';
            $packet{value} = oct '0b' . join "", map { substr $_, 1 } @groups;
        }
    } else {
        if (substr $bin, 0, 1, "") { # Number of sub-packets
            my $count = oct '0b' . substr $bin, 0, 11, "";
            for (1 .. $count) {
                my ($p, $rest) = packet($bin);
                push @{ $packet{packets} }, $p;
                $packet{sum} += $p->{version} + $p->{sum};
                $bin = $rest;
            }
        } else { # Length of subpackets
            my $length = oct '0b' . substr $bin, 0, 15, "";
            while ($length) {
                my ($p, $rest) = packet($bin);
                $length -= length($bin) - length $rest;
                push @{ $packet{packets} }, $p;
                $packet{sum} += $p->{version} + $p->{sum};
                $bin = $rest;
            }

        }
    }
    return \%packet, $bin
}

while (<>) {
    chomp;
    my ($packet, $rest) = packet(unpack 'B*', pack 'H*', $_);
    warn "GARBAGE" if $rest =~ 1;
    say $packet->{sum} + $packet->{version};
}

__DATA__
D2FE28
38006F45291200
EE00D40C823060
8A004A801A8002F478
620080001611562C8802118E34
C0015000016115A2E0802F182340
A0016C880162017C3686B18A3D4780
