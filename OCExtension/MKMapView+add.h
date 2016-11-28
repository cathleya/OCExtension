

#import <MapKit/MapKit.h>

@interface MKMapView (add)

- (void)setMapCenter:(CLLocationCoordinate2D)coordinate;
- (void)setMapCenter:(CLLocationCoordinate2D)coordinate withSpanSize:(CLLocationDegrees)spanSize;

@end
