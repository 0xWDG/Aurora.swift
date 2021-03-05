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
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: Needs to be decided.

#if canImport(Foundation)
import Foundation
#endif

#if canImport(MapKit) && !os(watchOS) && !os(tvOS)
import MapKit

public extension MKMapView {
    /// New Annotation
    /// - Parameters:
    ///   - coordinate: the coordinate
    ///   - title: the title
    ///   - subtitle: the subtitle
    func newAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
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
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let point = MKPointAnnotation.init()
        point.title = title
        point.subtitle = subtitle
        point.coordinate = coordinate
        self.addAnnotation(point)
    }
}
#endif
