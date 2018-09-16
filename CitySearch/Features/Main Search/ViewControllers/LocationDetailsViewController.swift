//  Copyright © 2018 Jon. All rights reserved.

import UIKit
import MapKit

class LocationDetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    // Experimented with a view differnet zoom spans
    let highSpan = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.50)
    let mediumHighSpan = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.50)
    let mediumSpan = MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050)
    let standardSpan = MKCoordinateSpan(latitudeDelta: 0.0050, longitudeDelta: 0.0050)
    let regionRadius: CLLocationDistance = 150

    // Default point shown on the map when the view is first loaded
    var fortySecondStreetNYC: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.758034, longitude: -73.991703)
        annotation.title = "New York"
        annotation.subtitle = "US"
        return annotation
    }

    var annotation: MKPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        centerMapAndAddAnnotationOn(annotation ?? fortySecondStreetNYC)
        zoomOutOnRegion()
    }

    // MARK: - Helper functions for adjusting the the levels on the map
    func zoomOutOnRegion() {
        let location = annotation?.coordinate ?? fortySecondStreetNYC.coordinate
        let coordinateRegion = MKCoordinateRegionMake(location,
                                                      highSpan)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func centerMapOn(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMake(location,
                                                      standardSpan)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func centerMapAndAddAnnotationOn(_ point: MKPointAnnotation) {
        centerMapOn(location: point.coordinate)
        mapView.addAnnotation(point)
    }

    func centerMapOnAnnotation() {
        guard let annotation = annotation else { return }

        centerMapOn(location: annotation.coordinate)
        mapView.addAnnotation(annotation)
    }

}

extension CityLocation {
    // Using as a bridge for the coordinates inorder to keep `CityLocation` a struct
    var annotation: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude,
                                                       longitude: coordinates.longitude)
        annotation.title = city
        annotation.subtitle = country
        return annotation
    }
}

