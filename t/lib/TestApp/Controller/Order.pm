package TestApp::Controller::Order;
use strict;
use warnings;
use Data::Dump qw( dump );
use base qw( Catalyst::Controller CatalystX::Controller::Tabs );

sub first : Local Tab('First','1') { }
sub second : Local Tab('Second','2') { }
sub third : Local Tab('Third','3') { }
sub fourth : Local Tab('Fourth','4') { }
sub fifth : Local Tab('Fifth','5') { }
sub sixth : Local Tab('Sixth','6') { }

1;
