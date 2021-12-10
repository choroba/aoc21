#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;


{   package SyntaxChecker;
    use Moo;
    has _stack => (is      => 'lazy',
                   builder => sub { [] },
                   clearer => '_clean_stack');

    my %score = (
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4,
    );
    my %expect = qw/ ( ) [ ] { } < > /;

    sub push_stack {
        my ($self, $ch) = @_;
        push @{ $self->_stack }, $ch;
    }

    sub pop_stack {
        my ($self) = @_;
        return pop @{ $self->_stack }
    }

    sub score {
        my ($self, $line) = @_;
        $self->_clean_stack;
        for my $ch (split //, $line) {
            if (exists $expect{$ch}) {
                $self->push_stack($expect{$ch});

            } elsif ($ch ne $self->pop_stack) {
                return 0
            }
        }
        my $score = 0;
        while (my $ch = $self->pop_stack) {
            $score *= 5;
            $score += $score{$ch};
        }
        return $score
    }
}

my @scores;
my $sc = 'SyntaxChecker'->new;
while (<>) {
    chomp;
    my $score = $sc->score($_);
    push @scores, $score if $score;
}
say +(sort { $a <=> $b } @scores)[@scores / 2];

__DATA__
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
