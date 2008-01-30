package TestApp::Controller::Global;
use strict;
use warnings;
use Data::Dump qw( dump );
use base qw( Catalyst::Controller CatalystX::Controller::Tabs );

sub g1 : Global Tab('Global 1') { }
sub g2 : Global Tab('Global 2') { }
sub g3 : Global Tab('Global 3') { }

1;
