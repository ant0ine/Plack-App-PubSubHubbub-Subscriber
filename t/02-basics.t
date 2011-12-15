#!perl -T

use Test::More tests => 2;

use Plack::App::PubSubHubbub::Subscriber;
use Plack::App::PubSubHubbub::Subscriber::Config;

my $conf = Plack::App::PubSubHubbub::Subscriber::Config->new(
    callback => 'http://example.tld:8081/callback?arg1=1',
);

my $s = Plack::App::PubSubHubbub::Subscriber->new(
    config => $conf,
);

isa_ok $s, 'Plack::App::PubSubHubbub::Subscriber';

is $s->callback_path, '/callback', 'just the path';
