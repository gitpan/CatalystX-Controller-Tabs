#!/usr/bin/perl -w
##################
# Copyright Jason Kohles (JSK), <email@jasonkohles.com>
# $Id$
##################
use strict;
use warnings;
use FindBin qw( $Bin );
use lib "$Bin/lib";
eval "use TestApp";
if ( $@ ) { plan skip_all => "Couldn't load TestApp: $@"; exit; }
use Test::WWW::Mechanize::Catalyst 'TestApp';
use Data::Dump qw( dump );
use Carp qw( croak verbose );
use Test::More;
use Scalar::Util qw( blessed );

{
    my $mech = Test::WWW::Mechanize::Catalyst->new;
    sub mech { $mech }
}
{
    my $numtabs;
    sub numtabs {
        if ( @_ ) { $numtabs = shift }
        return $numtabs;
    }
}
{
    my $tabs;
    sub settabs { $tabs = ref $_[0] eq 'ARRAY' ? $_[0] : \@_ }
    sub tabs { return wantarray ? @{ $tabs } : $tabs }
    sub tab { return $tabs->[ shift() - 1] }
}

sub matches_ok {
    my ( $item, $format, @vals ) = @_;
    my @check = map { sprintf( $format, $_ ) } 1 .. numtabs();
    if ( ! @vals ) { @vals = map { $_->{ $item } } tabs() }
    is_deeply( \@vals, \@check, "$item matches ok" );
}
sub list_ok {
    my ( $item, @list ) = @_;
    my @vals = map { $_->{ $item } } tabs();
    is_deeply( \@vals, \@list, "$item list matches ok" );
}

sub test_tabs {
    numtabs( shift() );
    get( shift() );
    my %opts = @_;

    for my $key ( sort keys %opts ) {
        my $exp = $opts{ $key };
        my @objects = tabs();

        my @expected = ( $exp ) x scalar @objects;
        if ( ! ref( $exp ) ) {
            if ( $exp =~ /%d/ ) {
                @expected = map { sprintf( $exp, $_ ) } 1 .. @objects;
            } elsif ( $exp =~ /\%\{(\w+)\}/ ) {
                my $x = $1;
                for my $i ( 0 .. $#expected ) {
                    my $val = get_value( $x => $objects[ $i ] );
                    $expected[ $i ] =~ s/\%\{$x\}/$val/g;
                }
            }
        } elsif ( ref $exp eq 'ARRAY' ) {
            @expected = @{ $exp };
        }

        my $sub;
        if ( $key =~ s/^(\w+)\.// ) {
            $sub = $1;
            @objects = map { get_value( $sub => $_ ) } @objects;
        }

        my $func = "_test_".$key;
        if ( defined &{ $func } ) {
            no strict 'refs';
            $func->( $exp => @objects );
            next;
        }

        my @got;
        for my $i ( 0 .. $#objects ) {
            if ( ! ref $expected[ $i ] ) {
                push( @got, get_value( $key => $objects[ $i ] ) );
            } elsif ( ref $expected[ $i ] eq 'ARRAY' ) {
                push( @got, [ get_value( $key => $objects[ $i ] ) ] );
            } elsif ( ref $expected[ $i ] eq 'HASH' ) {
                push( @got, { get_value( $key => $objects[ $i ] ) } );
            } else {
                die "Unknown got value!";
            }
        }

        if ( ! @got ) { die "No values for \@got!" }
        if ( ! @expected ) { die "No values for \@expected!" }

        is_deeply( \@got, \@expected, $sub ? "$sub $key" : $key );
    }
}

sub get_value {
    my ( $key, $object ) = @_;
    if ( blessed $object && $object->can( $key ) ) {
        return $object->$key();
    } else {
        #if ( ref $object ne 'HASH' ) { diag dump $object, $key, caller }
        return $object->{ $key };
    }
}

sub _test_name_order {
    my @order = @{ shift() };
    my @names = map { $_->{ 'name' } } tabs();

    is_deeply( \@names, \@order, "order" );
}

sub _test_selected {
    my $sel = shift;

    my @exp = ( 0 ) x scalar @_;
    $exp[ $sel - 1 ] = 1;
    
    my @got = map { $_->{ 'selected' } } @_;
    is_deeply( \@got, \@exp, "selected" );
}

sub _test_query_form {
    my $query = shift;

    my @got = ();
    my @exp = ( $query ) x scalar @_;
    for my $obj ( @_ ) {
        my @form = $obj->query_form;
        my $tmp = {};
        while ( my ( $key, $value ) = splice( @form, 0, 2 ) ) {
            if ( my $x = $tmp->{ $key } ) {
                $tmp->{ $key } = [ sort
                    ref $x ? @{ $x } : ( $x ),
                    $value,
                ];
            } else {
                $tmp->{ $key } = $value;
            }
        }
        push( @got, $tmp );
    }
    is_deeply( \@got, \@exp, "query_form" );
}

sub get_ok { mech()->get_ok( @_ ) }
sub get {
    my ( $uri, $count )  = @_;
    get_ok( "http://localhost$uri", "Retrieved $uri" );
    ok( my $t = eval content(), 'loaded content' );
    is( @{ $t }, numtabs(), "Correct number of tabs" );
    settabs( $t );
}

sub content { mech()->content }

1;
