#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Image::PNM;

my $image = Image::PNM->new('t/data/P4.pbm');

is($image->width, 6);
is($image->height, 8);
is($image->max_pixel_value, 1);
is_deeply($image->raw_pixel(1, 2), [0, 0, 0]);
is_deeply($image->pixel(4, 1), [0, 0, 0]);

is($image->as_string('P1'), <<IMAGE);
P1
6 8
0 0 0 0 0 0
0 0 1 1 0 0
0 1 0 0 1 0
1 0 0 0 0 1
1 1 1 1 1 1
1 0 0 0 0 1
1 0 0 0 0 1
0 0 0 0 0 0
IMAGE

is($image->as_string('P2'), <<IMAGE);
P2
6 8
1
1 1 1 1 1 1
1 1 0 0 1 1
1 0 1 1 0 1
0 1 1 1 1 0
0 0 0 0 0 0
0 1 1 1 1 0
0 1 1 1 1 0
1 1 1 1 1 1
IMAGE

is($image->as_string('P3'), <<IMAGE);
P3
6 8
1
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1
1 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 1
0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
IMAGE

is($image->as_string('P4') . "\n", <<IMAGE);
P4
6 8
\x00\x30\x48\x84\xfc\x84\x84\x00
IMAGE

is($image->as_string('P5') . "\n", <<IMAGE);
P5
6 8
1
\x01\x01\x01\x01\x01\x01\x01\x01\x00\x00\x01\x01\x01\x00\x01\x01\x00\x01\x00\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x01\x01\x01\x00\x00\x01\x01\x01\x01\x00\x01\x01\x01\x01\x01\x01
IMAGE

done_testing;
