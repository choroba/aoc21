#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $sum = 0;
while (<>) {
    my @digits = map join("", sort split //), split / \| |\s/;
    my @summable = splice @digits, -4;
    my %mapping = (abcdefg => 8);;

    my ($d7) = grep 3 == length, @digits;
    $mapping{$d7} = 7;

    my ($d1) = grep 2 == length, @digits;
    $mapping{$d1} = 1;

    ($mapping{A}) = $d7 =~ /([^$d1])/;

    my ($d4) = grep 4 == length, @digits;
    $mapping{$d4} = 4;
    my ($d9) = grep 6 == length && (my $c = () = /([$d4])/g) == 4, @digits;
    $mapping{$d9} = 9;
    $mapping{E} = 'abcdefg' =~ s/[$d9]//gr;
    $mapping{G} = $d9 =~ s/[$d7$d4]//gr;

    for my $d0 (grep 6 == length, @digits) {
        my $c = () = $d0 =~ /([^$d7$mapping{E}$mapping{G}])/g;
        next if 1 != $c;

        $mapping{B} = $1;
        $mapping{$d0} = 0;
        $mapping{D} = 'abcdefg' =~ s/[$d0]//gr;
    }

    my $p = join "", @mapping{qw{ A B E G D }};
    my ($d6) = grep 6 == length && (my $c1 = () = /[^$p]/g) == 1, @digits;
    $mapping{$d6} = 6;
    $mapping{C} = $d1 =~ s/([$d6])//gr;
    $mapping{F} = $1;

    for my $d (grep 5 == length, @digits) {
        my $p = join "", map 0+($d =~ /$mapping{$_}/), qw( C F );
        $mapping{$d} = {'01' => 5, '10' => 2, '11' => 3}->{$p};
    }

    my $n = join "", @mapping{@summable};
    $sum += $n;
}
say $sum;

# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
__DATA__
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
