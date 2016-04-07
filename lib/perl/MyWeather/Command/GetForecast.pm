package MyWeather::Command::GetForecast;

use strict;
use warnings;

use URI::Escape;
use MyWeather::Logic::Forecast;

sub run {
    my $self = shift;

    my $r = Apache2::RequestUtil->request();
    $r->status(200);
    $r->content_type('text/html');

    my $args       = $r->args;
    my $parsed_args = parse_query($args);

    my $body_string = "<html><body>\n";
    $body_string .= "The Wather Page<br />";

    $body_string .= MyWeather::Logic::Forecast->get_forecast_data( postal_code => $parsed_args->{postal_code} );

    $body_string .= "</html></body>\n";

    print $body_string;
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

