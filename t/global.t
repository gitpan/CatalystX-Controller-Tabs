#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
require "$FindBin::Bin/test-lib.pl";
use Test::More tests => 26;

test_tabs( 3, '/g1',
    selected            => 1,
    'uri.path'          => '/g%d',
    label               => 'Global %d',
    name                => 'g%d',
    name_order          => [qw( g1 g2 g3 )],
);

test_tabs( 3, '/g2/foo/bar',
    selected            => 2,
    'uri.path'          => '/g%d/foo/bar',
    label               => 'Global %d',
    name                => 'g%d',
    name_order          => [qw( g1 g2 g3 )],
);

test_tabs( 3, '/g3/foo?bar=baz',
    selected            => 3,
    'uri.path'          => '/g%d/foo',
    label               => 'Global %d',
    name                => 'g%d',
    name_order          => [qw( g1 g2 g3 )],
    'uri.scheme'        => 'http',
    'uri.query'         => 'bar=baz',
);
