package Plack::App::PubSubHubbub::Subscriber::Config;
use strict;
use warnings;

use URI;

=head1 NAME

Plack::App::PubSubHubbub::Subscriber::Config

=head1 SYNOPSIS

 Plack::App::PubSubHubbub::Subscriber::Config->new(
    callback => 'http://example.org/callback',
    verify => 'sync',
    lease_seconds => 86400,
 );

=head1 DESCRIPTION

=head2 $class->new( %args )

'callback' is required, must be 'http', must not contain fragment.
'verify' can be 'sync' or 'async', and defaults to 'sync'.
'lease_seconds' defaults to undef

=cut

sub new {
    my $class = shift;
    my %args = @_;
    my $self = bless {}, $class;

    my $verify = $args{verify} || 'sync';
    die "verify must be 'sync' or 'async'"
        unless $verify eq 'sync' || $verify eq 'async';
    $self->{verify} = $verify;

    my $cb = $args{callback}
        or die "'callback' required";
    my $uri = URI->new($cb)
        or die "invalid callback";
    die "support only http"
        unless $uri->scheme eq 'http';
    die "fragment is not accepted in the callback"
        if $uri->fragment;
    $self->{callback} = $cb;

    my $lease = $args{lease_seconds};
    if (defined $lease) {
        die "invalid number of seconds"
            unless $lease >= 0;
    }
    $self->{lease_seconds} = $lease;

    return $self;
}

sub callback { $_[0]->{callback} }

sub verify { $_[0]->{verify} }

sub lease_seconds { $_[0]->{lease_seconds} }

1;
