package MyWeather::Logic::Forecast;

use strict;
use warnings;

use MyWeather::Model::Forecast;
use Data::Dumper;
use Erik qw( log );

sub get_forecast_data {
    my $self = shift;
    my %args = @_;

    my $weather_data = MyWeather::Model::Forecast->load_data( postal_code => $args{postal_code} );

    my @content;
    push @content, "Sky: " . $weather_data->{weather_data}->[0]->{main};

    return join("<br />\n", @content);
}

1;
