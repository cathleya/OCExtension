

#import "MKMapView+add.h"

#define DEFAULT_SPAN   0.016

@implementation MKMapView (add)

- (void)setMapCenter:(CLLocationCoordinate2D)coordinate
{
    return [self setMapCenter:coordinate withSpanSize:DEFAULT_SPAN];
}

- (void)setMapCenter:(CLLocationCoordinate2D)coordinate withSpanSize:(CLLocationDegrees)spanSize
{
    if (coordinate.latitude >= -90.0
        && coordinate.latitude <= 90.0
        && coordinate.longitude >= -180.0
        && coordinate.longitude <= 180.0)
    {
        MKCoordinateSpan span = MKCoordinateSpanMake(spanSize,spanSize);
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
        region = [self regionThatFits:region];
        [self setRegion:region];
    }
}

@end
