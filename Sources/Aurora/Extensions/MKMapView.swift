// $$HEADER$$

import Foundation
import MapKit

extension MKMapView {
    public func newAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let x = MKPointAnnotation.init()
        x.title = title
        x.subtitle = subtitle
        x.coordinate = coordinate
        self.addAnnotation(x)
    }
    
    public func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let x = MKPointAnnotation.init()
        x.title = title
        x.subtitle = subtitle
        x.coordinate = coordinate
        self.addAnnotation(x)
    }
}
