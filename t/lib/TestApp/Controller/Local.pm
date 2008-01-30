package TestApp::Controller::Local;
use strict;
use warnings;
use Data::Dump qw( dump );
use base qw( Catalyst::Controller CatalystX::Controller::Tabs );

sub main : Path { }
sub local1 : Local Tab('Local 1') { }
sub local2 : Local Tab('Local 2') { }
sub local3 : Local Tab('Local 3') { }
sub local4 : Local Tab('Local 4') { }
sub local5 : Local Tab('Local 5') { }

1;
