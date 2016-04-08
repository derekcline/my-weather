package MyWeather::Logic::Forecast;

use strict;
use warnings;

use MyWeather::Model::Forecast;
use Data::Dumper;
use Erik qw( log );

sub get_forecast_data {
    my $self = shift;
    my %args = @_;

    my $weather_data = MyWeather::Model::Forecast->load_data(%args);
    Erik::dump( weather_data => $weather_data );

    my @content;
    push @content, sprintf "Sky: %s", $weather_data->{weather}->[0]->{main};
    push @content, sprintf "Temperature: %s&deg;", $weather_data->{main}->{temp};
    push @content, "Test - Data";

    return join("<br />\n", @content);
}

1;
