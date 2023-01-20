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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        let latitude: CLLocationDegrees = 43.64
        let longitude: CLLocationDegrees = -79.38
    }


}

