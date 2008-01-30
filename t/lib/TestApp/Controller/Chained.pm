package TestApp::Controller::Chained;
use strict;
use warnings;
use Data::Dump qw( dump );
use base qw( Catalyst::Controller CatalystX::Controller::Tabs );

sub main : Chained('/') PathPart('chained') CaptureArgs(0) { }

sub chain1 : Chained('main') Tab('Chain 1') Args(0) { }
sub chain2 : Chained('main') Tab('Chain 2') Args(0) { }
sub chain3 : Chained('main') Tab('Chain 3') Args(0) { }
sub chain4 : Chained('main') Tab('Chain 4') Args(0) { }
sub chain5 : Chained('main') Tab('Chain 5') Args(0) { }

1;
