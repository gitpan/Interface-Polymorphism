package ex::interface;

use strict;

require 5.6.0;
our $VERSION = "0.1";


sub import {
    my $self = shift;
    my %__METHOD = map {$_ => 1} @_;
    my $interface = caller;
    $interface .= '::';
    $::{$interface}{__METHOD} = \%__METHOD;
    $::{$interface}{AUTOLOAD} = \&their_AUTOLOAD;
}

sub their_AUTOLOAD {
    our $AUTOLOAD = $AUTOLOAD;
    $AUTOLOAD =~ s/(.*):://;
    my $interface = $1;
    if ($ {$::{"$interface\::__METHOD"}{$AUTOLOAD}}) {
        require Carp;
        Carp::croak("The interface method '$AUTOLOAD' has not been implemented");
    }
    else {
        my $self = shift;
        $AUTOLOAD =~ s/^/SUPER::/;
        $self->$AUTOLOAD(@_);
    }
}
1;
