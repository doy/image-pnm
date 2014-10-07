package Image::PNM;
use strict;
use warnings;

sub new {
    my $class = shift;
    my ($data) = @_;

    my $self = bless {}, $class;

    if (ref $data) {
        $self->_parse_string($data);
    }
    elsif ($data) {
        $self->_parse_file($data);
    }
    else {
        $self->{w}      = 1;
        $self->{h}      = 1;
        $self->{max}    = 1;
        $self->{pixels} = [[0]];
    }

    return $self;
}

sub as_string {
    my $self = shift;
    my ($format) = @_;

    my $method = "_as_string_$format";
    die "Unknown format $format"
        unless $self->can($method);

    return $self->$method;
}

sub width {
    my $self = shift;
    return $self->{w};
}

sub height {
    my $self = shift;
    return $self->{h};
}

sub max_pixel_value {
    my $self = shift;
    return $self->{max};
}

sub pixel {
    my $self = shift;
    my ($row, $col) = @_;

    my $pixel = $self->raw_pixel($row, $col);
    return [ map { $_ / $self->{max} } @$pixel ];
}

sub raw_pixel {
    my $self = shift;
    my ($row, $col) = @_;

    my $pixel = $self->{pixels}[$row][$col];
    die "invalid pixel location ($row, $col)"
        unless defined $pixel;

    if (!ref $pixel) {
        $pixel = [ $pixel, $pixel, $pixel ];
    }

    return $pixel;
}

sub _as_string_P3 {
    my $self = shift;

    my $data = <<HEADER;
P3
$self->{w} $self->{h}
$self->{max}
HEADER

    for my $row (@{ $self->{pixels} }) {
        $data .= join(' ', map { join(' ', @$_) } @$row) . "\n";
    }

    return $data;
}

sub _parse_string {
    my $self = shift;
    my ($string) = @_;

    return $self->_parse_pnm(sub {
        my ($line, $rest) = split /\n/, $string, 2;
        return unless length($line) || length($rest);
        $string = $rest;
        return "$line\n";
    });
}

sub _parse_file {
    my $self = shift;
    my ($filename) = @_;

    open my $fh, '<', $filename
        or die "Couldn't open $filename for reading: $!";

    return $self->_parse_pnm(sub { scalar <$fh> });
}

sub _parse_pnm {
    my $self = shift;
    my ($next_line) = @_;

    my $next_line_nocomments = sub {
        my $line;
        while (!length($line)) {
            $line = $next_line->();
            return unless defined($line);
            $line =~ s/#.*//s;
        }
        return $line;
    };

    chomp(my $format = $next_line_nocomments->());
    chomp(my $dimensions = $next_line_nocomments->());

    my ($w, $h) = $dimensions =~ /^([0-9]+)\s+([0-9]+)$/;
    die "Invalid dimensions: $dimensions"
        unless $w && $h;
    $self->{w} = $w;
    $self->{h} = $h;

    my $method = "_parse_pnm_$format";
    die "Don't know how to parse PNM files of format $format"
        unless $self->can($method);
    return $self->$method($next_line_nocomments);
}

sub _parse_pnm_P3 {
    my $self = shift;
    my ($next_line) = @_;

    chomp (my $max = $next_line->());
    die "Invalid max color value: $max"
        unless $max =~ /^[0-9]+$/ && $max > 0;
    $self->{max} = $max;

    my @words;
    my $next_word = sub {
        if (!@words) {
            chomp(my $line = $next_line->());
            @words = split ' ', $line;
        }
        my $word = shift @words;
        die "Invalid color: $word" unless $word =~ /^[0-9]+$/;
        return $word;
    };

    $self->{pixels} = [];
    for my $i (1..$self->{h}) {
        my $row = [];
        for my $j (1..$self->{w}) {
            push @$row, [
                $next_word->(),
                $next_word->(),
                $next_word->(),
            ];
        }
        push @{ $self->{pixels} }, $row;
    }
}

1;
