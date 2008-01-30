package TestApp::Controller::Root;
use strict;
use warnings;
use Data::Dump qw( dump );
use base qw( Catalyst::Controller CatalystX::Controller::Tabs );

__PACKAGE__->config( namespace => q{} );

sub auto : Private {
    my ( $self, $c ) = @_;

    $c->forward( 'build_tabs' );
}

sub main : Path { }

sub end : Private {
    my ( $self, $c ) = @_;

    if ( ! $c->response->body ) {
        $c->response->body( dump( $c->stash->{ 'tabs' } ) );
    }
}

sub default {
    my ( $self, $c ) = @_;

    $c->response->code( 404 );
}

1;
