//
//  ViewController.swift
//  A1_A2_iOS_ simran_c0870768
//
//  Created by simran mehra on 2023-01-20.
//

import UIKit
import MapKit
class ViewController: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var direction: UIButton!
    @IBOutlet weak var zoomIn: UIButton!
    @IBOutlet weak var zoomOut: UIButton!
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        map.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let latitude: CLLocationDegrees = 43.64
        let longitude: CLLocationDegrees = -79.38
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta*0.5, longitudeDelta: map.region.span.longitudeDelta*0.5)
        let region = MKCoordinateRegion(center: map.region.center, span: span)
        
        map.setRegion(region, animated: true)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta*2, longitudeDelta: map.region.span.longitudeDelta*2)
        let region = MKCoordinateRegion(center: map.region.center, span: span)
        
        map.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let userLocations = locations[0]
        
        let latitude = userLocations.coordinate.latitude
        let longitude = userLocations.coordinate.longitude
        
        displayLocation(latitude: latitude, longitude: longitude, title: "myLocation", subtitle: "I am here")
        
        
        func displayLocation(latitude: CLLocationDegrees,
                             longitude: CLLocationDegrees,
                             title: String,
                             subtitle: String) {

            let latDelta: CLLocationDegrees = 0.08
            let lngDelta: CLLocationDegrees = 0.08
            
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            map.setRegion(region, animated: true)
            
        }
    }

}
