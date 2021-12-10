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
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
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
                return $score{$ch}
            }
        }
        return 0
    }
}

my $score = 0;
my $sc = 'SyntaxChecker'->new;
while (<>) {
    chomp;
    $score += $sc->score($_);
}
say $score;

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
