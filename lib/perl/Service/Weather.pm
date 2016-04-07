package Service::Weather;

use strict;
use warnings;
use Data::Dumper;
use Apache2::RequestUtil;
use Apache2::RequestRec;
use LWP::UserAgent;
use JSON;
use URI::Escape;

sub run {
    my $self = shift;

    my $r = Apache2::RequestUtil->request();
    $r->status(200);
    $r->content_type('text/html');

    my $args       = $r->args;
    my $parsed_args = parse_query($args);

    print "<html><body>\n";
    print "The Wather Page<br />";

    # more stuff
    my $mode = 'GET';

    #my $uri  = 'http://api.openweathermap.org/data/2.5/forecast/city?id=524901&APPID=c2d4d0665857643942c6c7265c422265';
    my $uri = sprintf "http://api.openweathermap.org/data/2.5/weather?zip=%s,us&APPID=c2d4d0665857643942c6c7265c422265", $parsed_args->{postal_code};

    my $ua = LWP::UserAgent->new();
    my $req = HTTP::Request->new(GET => $uri);

    #$req->content($content);
    $req->content_type('application/json');
    $req->header(Accept => 'application/json');
    my $res = $ua->request($req);

    if ($res->is_success) {
        my $w = decode_json($res->content);

        #print "API call status: " . $res->content() . "\n";
        print "<p/>It is nice outside today.<br />";
        my @content;
        push @content, "Sky: " . $w->{weather}->[0]->{main};
        print join("<br />\n", @content);
    }

    print "</html></body>\n";
    return Apache2::Const::OK;
}

sub parse_query {
    my ($query, $params) = @_;
    $params ||= {};
    foreach my $var (split(/&/, $query)) {
        my ($k, $v) = split(/=/, $var);
        $k = uri_unescape $k;
        $v = uri_unescape $v;
        if (exists $params->{$k}) {
            if ('ARRAY' eq ref $params->{$k}) {
                push @{$params->{$k}}, $v;
            } else {
                $params->{$k} = [$params->{$k}, $v];
            }
        } else {
            $params->{$k} = $v;
        }
    }
    return $params;
}

1;


