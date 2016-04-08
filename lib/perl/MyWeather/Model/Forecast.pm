package MyWeather::Model::Forecast;

use strict;
use warnings;

use Data::Dumper;
use Apache2::RequestUtil;
use Apache2::RequestRec;
use LWP::UserAgent;
use Erik qw( log );
use JSON;

sub load_data {
    my $self = shift;
    my %args = @_;

    # API docs: http://openweathermap.org/current
    my $uri = sprintf "http://api.openweathermap.org/data/2.5/weather?zip=%s,us&units=%s&APPID=c2d4d0665857643942c6c7265c422265", $args{postal_code}, $args{units};
    Erik::warn("uri: $uri");

    my $ua = LWP::UserAgent->new();
    my $req = HTTP::Request->new(GET => $uri);

    $req->content_type('application/json');
    $req->header(Accept => 'application/json');
    my $res = $ua->request($req);
    #Erik::dump( res => $res );

    my $forecast_string;
    if ($res->is_success) {
        return decode_json($res->content);
    }
}

1;
