#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
require "$FindBin::Bin/test-lib.pl";
use Test::More tests => 9;

my @order = qw( first second third fourth fifth sixth );
test_tabs( 6, '/order/third',
    selected        => 3,
    'uri.path'      => '/order/%{name}',
    name_order      => \@order,
    order           => [qw( 1 2 3 4 5 6 )],
    label           => [ map { ucfirst } @order ],
    name            => \@order,
);
