#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum0 };

use constant MATCH => sum0(1 .. 11);

sub transform {
    my ($bj, @transformation) = @_;
    my $tj = [@$bj];

    for my $i (0 .. 2) {
        if ($transformation[$i] < 0) {
            $tj->[$i] *= -1;
            $transformation[$i] *= -1;
        }
    }

    my $rj = [0, 0, 0];
    $rj->[ $transformation[$_] - 1 ] = $tj->[$_] for 0, 1, 2;

    return $rj
}

my @scanners;

while (<>) {
    next if "\n" eq $_;
    if (/---/) {
        push @scanners, [];
    } else {
        chomp;
        push @{ $scanners[-1] }, [split /,/];
    }
}

my @relative;
for my $si (0 .. $#scanners) {
    for my $i (0 .. $#{ $scanners[$si] } - 1) {
        for my $j ($i + 1 .. $#{ $scanners[$si] } ) {
            push @{ $relative[$si] }, [
                map $scanners[$si][$i][$_] - $scanners[$si][$j][$_], 0 .. 2];
        }
    }
}

my @similar;
for my $si (0 .. $#scanners - 1) {
    for my $sj ($si + 1 .. $#scanners) {
        for my $bi (0 .. $#{ $relative[$si] }) {
            for my $bj (0 .. $#{ $relative[$sj] }) {
                my $bis = join ' ', sort map abs, @{ $relative[$si][$bi] };
                my $bjs = join ' ', sort map abs, @{ $relative[$sj][$bj] };
                if ($bis eq $bjs) {
                    my @similarity;
                    for my $i (0 .. 2) {
                        for my $j (0 .. 2) {
                            if (abs $relative[$si][$bi][$i]
                                == abs $relative[$sj][$bj][$j]
                            ) {
                                push @{ $similarity[$i] },
                                     $relative[$si][$bi][$i]
                                     != $relative[$sj][$bj][$j]
                                     ? - $j - 1
                                     : $relative[$si][$bi][$i] ? $j + 1 : 0;
                            }
                        }
                    }
                    my $vector = join ':', map "@$_", @similarity;
                    ++$similar[$si][$sj]{$vector};
                    ++$similar[$sj][$si]{$vector};
                }
            }
        }
    }
}

my @neighbours = map { scalar grep MATCH == sum0(values %{ $_ // {} }), @$_ }
                 @similar;
my @by_neighbours = sort { $neighbours[$b] <=> $neighbours[$a] }
                    0 .. $#scanners;
my %grid;
for my $s (@{ $scanners[ $by_neighbours[0] ] }) {
    my ($x, $y, $z) = @$s;
    undef $grid{"$x $y $z"}{ $by_neighbours[0] };
}

my @agenda = map [$_, $by_neighbours[0]],
             grep 66 == sum0(values %{ $similar[ $by_neighbours[0] ][$_] }),
             0 .. $#scanners;
my %processed = ($by_neighbours[0] => []);

my %beacon;
++$beacon{"@$_"} for @{ $scanners[ $by_neighbours[0] ] };

while (@agenda) {
    my ($sj, $si) = @{ shift @agenda };
    next if $processed{$sj};

    push @agenda,
         map [$_, $sj],
         grep 66 == sum0(values %{ $similar[$sj][$_] }),
         grep ! $processed{$_},
         0 .. $#scanners;

    my %bi;
    undef $bi{"@$_"} for @{ $scanners[$si] };
    my (@t, @v);
  TRANSFORM:
    for my $order ([1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]) {
        for my $neg (0 .. oct '0b111') {
            my @transformation = @$order;
            my $binneg = sprintf '%03b', $neg;
            $transformation[$_] *= -1 for grep substr($binneg, $_, 1), 0, 1, 2;

            for my $bi0 (@{ $scanners[$si] }) {
                for my $bj0 (@{ $scanners[$sj] }) {
                    my $common = 0;
                    my $tj0 = transform($bj0, @transformation);
                    my @vector = map $bi0->[$_] - $tj0->[$_], 0, 1, 2;
                    for my $bj (@{ $scanners[$sj] }) {
                        my $tj = transform($bj, @transformation);
                        my @vj = map $vector[$_] + $tj->[$_], 0, 1, 2;
                        ++$common if exists $bi{"@vj"};
                    }
                    if ($common >= 12) {
                        @v = @vector;
                        @t = @transformation;
                        last TRANSFORM
                    }
                }
            }
        }
    }
    die unless @v;

    $processed{$sj} = [@{ $processed{$si} }, [@t, @v]];
    for my $bj (@{ $scanners[$sj] }) {
        my $tj = [@$bj];
        for my $p (reverse @{ $processed{$sj} }) {
            my @tr = @$p[0 .. 2];
            my @vec = @$p[3 .. 5];
            $tj = transform($tj, @tr);
            $tj = [map $vec[$_] + $tj->[$_], 0, 1, 2];
        }
        ++$beacon{"@$tj"};
    }
}
say scalar keys %beacon;

__DATA__
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
