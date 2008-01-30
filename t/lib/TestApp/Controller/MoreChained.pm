package TestApp::Controller::MoreChained;
use strict;
use warnings;
use Data::Dump qw( dump );
use base qw( Catalyst::Controller CatalystX::Controller::Tabs );

sub morechain1 : Chained('/chained/main') Tab('More Chain 1') Args(3) { }
sub morechain2 : Chained('/chained/main') Tab('More Chain 2') Args(3) { }
sub morechain3 : Chained('/chained/main') Tab('More Chain 3') Args(3) { }
sub morechain4 : Chained('/chained/main') Tab('More Chain 4') Args(3) { }

1;
