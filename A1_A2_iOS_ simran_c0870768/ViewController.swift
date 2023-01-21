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
    
    @IBOutlet weak var userLocation: UIButton!
    
    var locationManager: CLLocationManager!
    var destination1: CLLocationCoordinate2D!
    var CustomDistance: [UILabel] = []
    var pinnedAnnotations: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        map.isZoomEnabled = false
        singleTap()
       
        
       // for removing annotation
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(removeAnnotation))
        longPress.delaysTouchesBegan = true
        map.addGestureRecognizer(longPress)
       
        
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta*0.5, longitudeDelta: map.region.span.longitudeDelta*0.5)
        let region = MKCoordinateRegion(center: map.region.center, span: span)
        
        map.setRegion(region, animated: true)
    }
    
    @IBAction func userLocation(_ sender: UIButton) {
        map.showsUserLocation = true
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta*2, longitudeDelta: map.region.span.longitudeDelta*2)
        let region = MKCoordinateRegion(center: map.region.center, span: span)
        
        map.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        let userLocations = locations[0]
        
        let latitude = userLocations.coordinate.latitude
        let longitude = userLocations.coordinate.longitude
        
        displayLocation(latitude: latitude, longitude: longitude, title: "myLocation", subtitle: "I am here")
        
        
        func displayLocation(latitude: CLLocationDegrees,
                             longitude: CLLocationDegrees,
                             title: String,
                             subtitle: String) {
            
            let latDelta: CLLocationDegrees = 0.14
            let lngDelta: CLLocationDegrees = 0.14
            
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            map.setRegion(region, animated: true)
            
        }
        
    }
    
    func removeOverlays() {
    
        for polygon in map.overlays {
            map.removeOverlay(polygon)
        }
    }
    private func removeLabel() {
        for label in CustomDistance {
            label.removeFromSuperview()
        }
        
        CustomDistance = []
    }
 
    func addPolygon() {

        var cityAnnotations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
   
        for count in map.annotations{
            if count.title == "My Location" {
                continue
            }
            cityAnnotations.append(count.coordinate)
        }

        let polygon = MKPolygon(coordinates: cityAnnotations, count: cityAnnotations.count)
        
        map.addOverlay(polygon)
    }
    func addPolyline() {
       
        var myAnnotations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for mapAnnotation in map.annotations {
            myAnnotations.append(mapAnnotation.coordinate)
        }
        myAnnotations.append(myAnnotations[0])
        
        let polyline = MKPolyline(coordinates: myAnnotations, count: myAnnotations.count)
        map.addOverlay(polyline, level: .aboveRoads)
       
        showDistanceBetweenTwoPoint()
    }
    
    private func showDistanceBetweenTwoPoint() {
        var nextIndex = 0
        
        for index in 0...2{
            if index == 2 {
                nextIndex = 0
            } else {
                nextIndex = index + 1
            }

            let distance: Double = getDistance(from: map.annotations[index].coordinate, to:  map.annotations[nextIndex].coordinate)
            
            let index1: CGPoint = map.convert(map.annotations[index].coordinate, toPointTo: map)
            let index2: CGPoint = map.convert(map.annotations[nextIndex].coordinate, toPointTo: map)
        
            let labelDistance = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 18))

            labelDistance.textAlignment = NSTextAlignment.center
            labelDistance.text = "\(String.init(format: "%2.f",  round(distance * 0.005))) km"
            labelDistance.textColor = .black
            labelDistance.backgroundColor = .white
            labelDistance.center = CGPoint(x: (index1.x + index2.x) / 2, y: (index1.y + index2.y) / 2)
            
            CustomDistance.append(labelDistance)
        }
        for label in CustomDistance {
            map.addSubview(label)
        }
    }

    
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        return from.distance(from: to)
    }

    @objc func dropPin(sender: UITapGestureRecognizer){

            pinnedAnnotations = map.annotations.count
            
            let touchPoint = sender.location(in: map)
            let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
                           
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: {(placemarks, error) in
                
                if self.pinnedAnnotations > 3 {
                    self.removePin()
                }
                else {
                    DispatchQueue.main.async {
                        if let placeMark = placemarks?[0] {
                            
                            if placeMark.locality != nil {
                                let place = city(coordinate: coordinate)
                            
                                if self.pinnedAnnotations <= 2 {
                                    self.map.addAnnotation(place)
                                }
                                if self.pinnedAnnotations == 2 {

                                    self.addPolyline()
                                    self.addPolygon()
                                                        }
                                            }
                        }
                    }
                }
    
            })
       
        
        }
    
   func singleTap(){
        let single = UITapGestureRecognizer(target: self, action: #selector(dropPin))
        single.numberOfTapsRequired = 1
        map.addGestureRecognizer(single)
    }
    func doubletap(){
         let double = UITapGestureRecognizer(target: self, action: #selector(removePin))
         double.numberOfTapsRequired = 2
         map.addGestureRecognizer(double)
     }


    @objc func removePin() {
        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }
    }
    @objc func removeAnnotation(point: UITapGestureRecognizer) {
      
        let pointTouched: CGPoint = point.location(in: map)
        
        let coordinate =  map.convert(pointTouched, toCoordinateFrom: map)
        let location: CLLocationCoordinate2D = coordinate
          
       
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                DispatchQueue.main.async {
                    if let placeMark = placemarks?[0] {
                        
                        if placeMark.locality != nil {
                            
                            for myAnnotation in self.map.annotations{

                                    self.removeOverlays()
                                    self.removeLabel()
                                    self.map.showsUserLocation = false
                                    self.map.removeAnnotation(myAnnotation)
                                }
                            }
                        }
                    }
                }
            
        })
    }
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        if annotation is MKUserLocation{
//            return nil
//        }
//
//        switch annotation.title {
//        case "A":
//            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker1")
//            annotationView.markerTintColor = UIColor.blue
//            return annotationView
//        case "B":
//            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker2")
//            annotationView.markerTintColor = UIColor.orange
//            annotationView.animatesWhenAdded = true
//            return annotationView
//        case "C":
//            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker3")
//            annotationView.markerTintColor = UIColor.black
//            annotationView.animatesWhenAdded = true
//            return annotationView
//        default:
//            return nil
//        }
//    }
    @IBAction func drawRoute(_ sender: UIButton) {
        removeOverlays()
        removeLabel()
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
        
