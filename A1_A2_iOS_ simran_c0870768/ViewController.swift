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
    var destination1: CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        
     
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        
        singleTap()
        
        direction.isHidden = true
        
//        let latitude: CLLocationDegrees = 43.64
//        let longitude: CLLocationDegrees = -79.38
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
    @objc func dropPin(sender: UITapGestureRecognizer){
        print(map.annotations.count)
        
        
        let touchPoint = sender.location(in: map)
        
        let coordinate1 = map.convert(touchPoint, toCoordinateFrom: map)
        
        let annotationCity = city(coordinate: coordinate1)
        
        map.addAnnotation(annotationCity)
        
        destination1 = coordinate1
        
        
        direction.isHidden = false
        print(map.annotations.count)
        
    }
    func singleTap(){
        let single = UITapGestureRecognizer(target: self, action: #selector(dropPin))
        single.numberOfTapsRequired = 1
        map.addGestureRecognizer(single)
    }
    
    @IBAction func drawRoute(_ sender: UIButton) {
        
        print(map.annotations.count)
        
        var nextIndex = 0
        for index in 0 ... 2 {
            if index == 2 {
                nextIndex = 0
            } else {
                nextIndex = index + 1
            }
            
            
            let source = MKPlacemark(coordinate: map.annotations[index].coordinate)
            
            let destination = MKPlacemark(coordinate: map.annotations[nextIndex].coordinate)
            
            let directionRequest = MKDirections.Request()
            
            directionRequest.source = MKMapItem(placemark: source)
            directionRequest.destination = MKMapItem(placemark: destination)
            
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate{ (response, error) in
                guard let directionResponse = response else {return}
                
                
                let route = directionResponse.routes[0]
                let distanceInMeters = route.distance
                let distanceInKilometers = distanceInMeters / 1000
                print("Distance between annotations: \(distanceInKilometers) kilometers")
                self.map.addOverlay(route.polyline, level: .aboveRoads)
                
            }
        }
        
    }
        
}
extension ViewController: MKMapViewDelegate {
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        switch annotation.title {
        case "A":
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker1")
            annotationView.markerTintColor = UIColor.blue
            return annotationView
        case "B":
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker2")
            annotationView.markerTintColor = UIColor.orange
            annotationView.animatesWhenAdded = true
            return annotationView
        case "C":
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker3")
            annotationView.markerTintColor = UIColor.black
            annotationView.animatesWhenAdded = true
            return annotationView
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let rendrer = MKCircleRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.green
            rendrer.lineWidth = 2
            return rendrer
        } else if overlay is MKPolyline {
            let rendrer1 = MKPolylineRenderer(overlay: overlay)
            rendrer1.strokeColor = UIColor.blue
            rendrer1.lineWidth = 3
            return rendrer1
        }
        else if overlay is MKPolygon {
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.red.withAlphaComponent(0.6)
            rendrer.strokeColor = UIColor.green
            rendrer.lineWidth = 2
            return rendrer}
        
        return MKOverlayRenderer()
    }
   
}

