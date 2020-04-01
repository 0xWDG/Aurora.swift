// $$HEADER$$

import Foundation
import MapKit

extension MKMapView {
    func newAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let x = MKPointAnnotation.init()
        x.title = title
        x.subtitle = subtitle
        x.coordinate = coordinate
        self.addAnnotation(x)
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let x = MKPointAnnotation.init()
        x.title = title
        x.subtitle = subtitle
        x.coordinate = coordinate
        self.addAnnotation(x)
    }
}
