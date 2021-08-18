// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Thanks for using!
//
// Licence: MIT

#if canImport(Foundation)
import Foundation
#endif

#if canImport(MapKit) && !os(watchOS) && !os(tvOS)
import MapKit

public extension MKMapView {
    /// A string-based annotation that you apply to a specific map point.
    ///
    /// This is a alias for ``addAnnotation``
    /// - Parameters:
    ///   - coordinate: The coordinate point of the annotation, specified as a latitude and longitude.
    ///   - title: The title of the shape annotation.
    ///   - subtitle: The subtitle of the shape annotation.
    func newAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.addAnnotation(
            coordinate: coordinate,
            title: title,
            subtitle: subtitle
        )
    }

    /// A string-based annotation that you apply to a specific map point.
    /// - Parameters:
    ///   - coordinate: The coordinate point of the annotation, specified as a latitude and longitude.
    ///   - title: The title of the shape annotation.
    ///   - subtitle: The subtitle of the shape annotation.
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.addAnnotation(MKPointAnnotation.init().configure {
            $0.title = title
            $0.subtitle = subtitle
            $0.coordinate = coordinate
        })
    }
}
#endif
