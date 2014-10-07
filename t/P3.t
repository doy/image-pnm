#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Image::PNM;

my $image = Image::PNM->new('t/data/P3.ppm');

is($image->width, 6);
is($image->height, 8);
is($image->max_pixel_value, 255);
is_deeply($image->raw_pixel(1, 2), [0, 84, 255]);
is_deeply($image->pixel(4, 1), [1, 0, 0]);

is($image->as_string('P3'), <<IMAGE);
P3
6 8
255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 0 84 255 0 84 255 255 255 255 255 255 255
255 255 255 0 0 0 255 255 255 255 255 255 0 0 0 255 255 255
0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0
0 0 0 255 0 0 255 0 0 255 0 0 255 0 0 0 0 0
0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0
0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
IMAGE

done_testing;
