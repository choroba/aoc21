#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum product min max };

my %TYPE = (4 => 'LITERAL',
            0 => 'SUM',
            1 => 'PRODUCT',
            2 => 'MINIMUM',
            3 => 'MAXIMUM',
            5 => 'GT',
            6 => 'LT',
            7 => 'EQ');
my %DISPATCH = (
    SUM     => sub { sum(@_) },
    PRODUCT => sub { product(@_) },
    MINIMUM => sub { min(@_) },
    MAXIMUM => sub { max(@_) },
    GT      => sub { $_[0] >  $_[1] ? 1 : 0 },
    LT      => sub { $_[0] <  $_[1] ? 1 : 0 },
    EQ      => sub { $_[0] == $_[1] ? 1 : 0 });

sub packet {
    my ($bin) = @_;
    my %packet;
    $packet{version} = (unpack 'C', pack 'B3', substr $bin, 0, 3, "") >> 5;
    $packet{type}
        = $TYPE{(unpack 'C', pack 'B3', substr $bin, 0, 3, "") >> 5};

    if ('LITERAL' eq $packet{type}) {
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
                $bin = $rest;
            }

        } else { # Length of subpackets
            my $length = oct '0b' . substr $bin, 0, 15, "";
            while ($length) {
                my ($p, $rest) = packet($bin);
                $length -= length($bin) - length $rest;
                push @{ $packet{packets} }, $p;
                $bin = $rest;
            }
        }
        $packet{value} = $DISPATCH{ $packet{type} }->(map $_->{value},
                                                      @{ $packet{packets} });
    }
    return \%packet, $bin
}

while (<>) {
    chomp;
    my ($packet, $rest) = packet(unpack 'B*', pack 'H*', $_);
    warn "GARBAGE" if $rest =~ 1;
    say $packet->{value};
}

__DATA__
C200B40A82
04005AC33890
880086C3E88112
CE00C43D881120
D8005AC2A8F0
F600BC2D8F
9C005AC2F8F0
9C0141080250320F1802104A08
