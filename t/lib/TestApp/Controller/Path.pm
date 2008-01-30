package TestApp::Controller::Path;
use strict;
use warnings;
use Data::Dump qw( dump );
use base qw( Catalyst::Controller CatalystX::Controller::Tabs );

sub p1 : Path('/p1') Tab('Path 1') { }
sub p2 : Path('/p2') Tab('Path 2') { }
sub p3 : Path('/p3') Tab('Path 3') { }

1;
