#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Image::PNM;

my $image = Image::PNM->new('t/data/P2.pgm');

is($image->width, 6);
is($image->height, 8);
is($image->max_pixel_value, 255);
is_deeply($image->raw_pixel(1, 2), [78, 78, 78]);
is_deeply($image->pixel(0, 0), [1, 1, 1]);

is($image->as_string('P2'), <<IMAGE);
P2
6 8
255
255 255 255 255 255 255
255 255 78 78 255 255
255 0 255 255 0 255
0 255 255 255 255 0
0 54 54 54 54 0
0 255 255 255 255 0
0 255 255 255 255 0
255 255 255 255 255 255
IMAGE

done_testing;
