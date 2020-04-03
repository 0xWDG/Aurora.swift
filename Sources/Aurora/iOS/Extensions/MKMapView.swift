// $$HEADER$$

#if canImport(Foundation)
import Foundation
#endif

#if canImport(MapKit)
import MapKit

extension MKMapView {
    /// New Annotation
    /// - Parameters:
    ///   - coordinate: the coordinate
    ///   - title: the title
    ///   - subtitle: the subtitle
    public func newAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let point = MKPointAnnotation.init()
        point.title = title
        point.subtitle = subtitle
        point.coordinate = coordinate
        self.addAnnotation(point)
    }
    
    /// Add Annotation
    /// - Parameters:
    ///   - coordinate: the coordinate
    ///   - title: the title
    ///   - subtitle: the subtitle
    public func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let point = MKPointAnnotation.init()
        point.title = title
        point.subtitle = subtitle
        point.coordinate = coordinate
        self.addAnnotation(point)
    }
}
#endif
