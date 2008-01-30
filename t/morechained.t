#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
require "$FindBin::Bin/test-lib.pl";
use Test::More tests => 8;

test_tabs( 4, '/chained/morechain4/one/two/three',
    selected        => 4,
    'uri.path'      => '/chained/morechain%d/one/two/three',
    label           => 'More Chain %d',
    name            => 'morechain%d',
    name_order      => [qw( morechain1 morechain2 morechain3 morechain4 )],
);
