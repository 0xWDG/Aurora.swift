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
        let x = MKPointAnnotation.init()
        x.title = title
        x.subtitle = subtitle
        x.coordinate = coordinate
        self.addAnnotation(x)
    }
    
    /// Add Annotation
    /// - Parameters:
    ///   - coordinate: the coordinate
    ///   - title: the title
    ///   - subtitle: the subtitle
    public func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let x = MKPointAnnotation.init()
        x.title = title
        x.subtitle = subtitle
        x.coordinate = coordinate
        self.addAnnotation(x)
    }
}
#endif
