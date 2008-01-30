#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
require "$FindBin::Bin/test-lib.pl";
use Test::More tests => 17;

test_tabs( 5, '/local/local3',
    selected        => 3,
    'uri.path'      => '/local/local%d',
    label           => 'Local %d',
    name            => 'local%d',
    name_order      => [qw( local1 local2 local3 local4 local5 )],
);

test_tabs( 5, '/local/local5/random/stuff?foo=bar&spork=spoon&spork=fork',
    selected    => 5,
    'uri.path'  => '/local/local%d/random/stuff',
    'uri.query_form'    => { foo => 'bar', spork => [ 'fork', 'spoon' ] },
    label           => 'Local %d',
    name            => 'local%d',
    name_order      => [qw( local1 local2 local3 local4 local5 )],
);
