package CatalystX::Controller::Tabs;
use strict;
use warnings;
our $VERSION = '0.02';
our $ID = '$Id: Tabs.pm 11 2008-01-30 15:18:52Z jason $';
use base qw( Catalyst::Controller );
use NEXT;

sub build_tabs : Private {
    my ( $self, $c ) = @_;

    my $conf = $self->config->{ 'tabs' } || {};

    my %tabs = ();
    my $selected;
    my $namespace = $c->action->namespace;
    for my $container ( $c->dispatcher->get_containers( $namespace ) ) {
        for my $action ( values %{ $container->actions } ) {
            my $attrs = $action->attributes;
            my $attr = $attrs->{ 'Tab' } || next;
            $attr = $attr->[ 0 ];
            my ( $label, $order ) = split( /','/, $attr );

            my $tab = $tabs{ $action->name } = {
                name        => $action->name,
                label       => $label,
                selected    => 0,
                order       => $order || 0,
                uri         => $c->uri_for(
                    $c->dispatcher->get_action( $action->name, $namespace ),
                    $c->request->captures,
                    @{ $c->request->arguments },
                    $c->request->query_params,
                ),
            };
        }
    }
    if ( $tabs{ $c->action->name } ) {
        $selected = $c->action->name;
        $tabs{ $selected }->{ 'selected' } = 1;
    }

    my @tabs = sort {
        $a->{ 'order' } <=> $b->{ 'order' }
            ||
        $a->{ 'label' } cmp $b->{ 'label' }
    } values %tabs;

    $c->stash->{ $conf->{ 'stash_key' } || 'tabs' } = \@tabs;
}

1;

__END__

=head1 NAME

CatalystX::Controller::Tabs - Automatically build tab sets for a controller

=head1 SYNOPSIS

  package MyApp::Controller::Something;
  use base qw( Catalyst::Controller CatalystX::Controller::Tabs );
  
  sub friends : Local Tab('Friends') {
    my ( $self, $c ) = @_;
    
    $c->stash->{ 'template' } = 'friends_list.tt2';
  }
  
  sub enemies : Local Tab('Enemies') {
    my ( $self, $c ) = @_;
    
    $c->stash->{ 'template' } = 'enemies_list.tt2';
  }
  
  sub auto : Private {
    my ( $self, $c ) = @_;
    
    $c->forward( 'build_tabs' )
  }

  [%# Template friends_list.tt2 %]
  [% PROCESS tabs.tt2 %]
  <ul>[% FOR enemy IN enemies %]<li>[% enemy %]</li>[% END %]</ul>
  
  [%# Template enemeies_list.tt2 %]
  [% PROCESS tabs.tt2 %]
  <ul>[% FOR friend IN friends %]<li>[% friend %]</li>[% END %]</ul>
  
  [%# Template friends_list.tt2 %]
  <ul>
  [% FOR tab IN tabs %]
      <li[% IF tab.selected %] class="selected">
          <a href="[% tab.uri %]">[% tab.label %]</a>
      </li>
  [% END %]
  </ul>

=head1 DESCRIPTION

This module allows you to add a 'Tab' attribute to action endpoints, and it
will automatically build a data structure suitable for rendering 'tabs' to
switch between the methods that share the same tab structure.

Although this was originally built to help with making tabbed interfaces, it
isn't limited to creating tabs, as it simply collects the information about
the related actions.  Actions are considered to be related if they share a
namespace.

=head1 METHODS

=head2 build_tabs

This is the only method provided by this module, and you need to make sure
you arrange to forward to this method when you want the tab data structure
to be built.

=head1 CONFIGURATION

You can configure this module with the normal L<Catalyst> style of controller
configuration.  The default configuration is:

    __PACKAGE__->config( {
        tabs    => {
            stash_key       => 'tabs',
        }
    } );

=head2 CONFIGURATION OPTIONS

=over

=item stash_key

This configuration option controls the key that will be used to store the
the generated data structure in the stash.

=back

=head1 SAMPLE CSS

Here is some CSS that works with the template included in the synopsis.  It's
probably not exactly what you need, but it should give a decent starting
point...

  ul.tabs {
    text-align: left;
    margin: 1em 0 1em 0;
    border-bottom: 1px solid #6c6;
    list-style-type: none;
    padding: 3px 10px 3px 10px;
  }
      
  ul.tabs li {
    display: inline;
  }
  
  ul.tabs li.selected {
    border-bottom: 1px solid #fff;
    background-color: #fff;
  }
  
  ul.tabs li.selected a {
    background-color: #fff;
    color: #000;
    position: relative;
    top: 1px;
    padding-top: 4px;
  }
  
  ul.tabs li a {
    padding: 3px 4px;
    border: 1px solid #6c6;
    background-color: #cfc;
    color: #666;
    margin-right: 0px;
    text-decoration: none;
    border-bottom: none;
  }
  
  ul.tabs a:hover {
    background: #fff;
}

=head1 SEE ALSO

L<http://www.jasonkohles.com/software/CatalystX-Controller-Tabs>

L<http://catalyst.perl.org/>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CatalystX::Controller::Tabs

You can also look for information at:

=over 4

=item * Project home page

L<http://www.jasonkohles.com/software/CatalystX-Controller-Tabs>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CatalystX-Controller-Tabs>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CatalystX-Controller-Tabs>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CatalystX-Controller-Tabs>

=item * Search CPAN

L<http://search.cpan.org/dist/CatalystX-Controller-Tabs>

=back

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalystx-controller-tabs
at rt.cpan.org>, or through the web interface at L<http://rt.cpan.org>.  I
will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head2 KNOWN BUGS

The methods provided for determining the URI for an action don't seem to work
the same way for L<Catalyst::DispatchType::Regex|Catalyst::DispatchType::Regex>
actions, but this hasn't been a big issue for me so far, and I haven't had
time to track the problem down yet (it seems to be an issue with
L<Catalyst::DispatchType::Regex/uri_for_action|uri_for_action in
Catalyst::DispatchType::Regex> if you want to look for it...)

=head1 AUTHOR

Jason Kohles C<< <email@jasonkohles.com> >> L<http://www.jasonkohles.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007-2008 Jason Kohles.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

