#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
require "$FindBin::Bin/test-lib.pl";
use Test::More tests => 8;

test_tabs( 5, '/chained/chain5',
    selected            => 5,
    name                => 'chain%d',
    label               => 'Chain %d',
    name_order          => [qw( chain1 chain2 chain3 chain4 chain5 )],
    'uri.path'          => '/chained/chain%d',
);
