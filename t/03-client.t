#!perl -T

use Test::More tests => 9;

use URI;

use Plack::App::PubSubHubbub::Subscriber::Client;
use Plack::App::PubSubHubbub::Subscriber::Config;

my $conf = Plack::App::PubSubHubbub::Subscriber::Config->new(
    callback => 'http://example.tld:8081/callback',
);

my $client = Plack::App::PubSubHubbub::Subscriber::Client->new(
    config => $conf,
);

isa_ok $client, 'Plack::App::PubSubHubbub::Subscriber::Client';

note 'subscribe';
{
    my $request = $client->subscribe_request(
        "http://hub.tld/",
        "http://feed.tld/atom.xml",
        "mytoken",
    );

    isa_ok $request, 'HTTP::Request';
    is $request->method, 'POST', 'method';
    is $request->uri, 'http://hub.tld/', 'uri';
    my $uri = URI->new('http:');
    $uri->query($request->content);
    my %args = $uri->query_form;
    my $expected = {
      'hub.topic' => 'http://feed.tld/atom.xml',
      'hub.mode' => 'subscribe',
      'hub.callback' => 'http://example.tld:8081/callback',
      'hub.verify' => 'sync',
      'hub.verify_token' => 'mytoken'
    };
    is_deeply(\%args, $expected, 'request content');
}

note 'unsubscribe';
{
    my $request = $client->unsubscribe_request(
        "http://hub.tld/",
        "http://feed.tld/atom.xml",
        "mytoken",
    );

    isa_ok $request, 'HTTP::Request';
    is $request->method, 'POST', 'method';
    is $request->uri, 'http://hub.tld/', 'uri';
    my $uri = URI->new('http:');
    $uri->query($request->content);
    my %args = $uri->query_form;
    my $expected = {
      'hub.topic' => 'http://feed.tld/atom.xml',
      'hub.mode' => 'unsubscribe',
      'hub.callback' => 'http://example.tld:8081/callback',
      'hub.verify' => 'sync',
      'hub.verify_token' => 'mytoken'
    };
    is_deeply(\%args, $expected, 'request content');
}
