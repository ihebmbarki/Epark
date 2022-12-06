//
//  RidesVC.swift
//  Epark
//
//  Created by iheb mbarki on 10/11/2022.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel

@available(iOS 14.0, *)
class RidesVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, FloatingPanelControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: 36.90058710633806,
                                         longitude: 10.18940253217338)
        setStartingLocation(location: initialLocation, distance: 1000)
        
        mapView.mapType = .hybrid
        addAnnotation()
        
//MARK: Floating Panel_Park
        
//        let fpc = FloatingPanelController()
//        fpc.delegate = self
//
//        guard let parkVC = storyboard?.instantiateViewController(withIdentifier: "fpc_park") as? ParkViewController
//        else {
//            return
//        }
//
//        fpc.set(contentViewController: parkVC)
//        fpc.addPanel(toParent: self)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
        
        if isLocationServiceEnabled() {
            checkAuthorization()
            
        } else {
            showAlert(msg: "Please enable location services")
        }
        
        
    }
    

    func setStartingLocation(location: CLLocation, distance: CLLocationDistance) {
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
//        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
//
//        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 300000)
//        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    func addAnnotation() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 36.90058710633806, longitude: 10.18940253217338)
        pin.title = "Esprit Park"
        pin.subtitle = "Click to Book a space"
        mapView.addAnnotation(pin)
    }
    
  
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            //Create the view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "park_pin")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        
        guard let parkVC = storyboard?.instantiateViewController(withIdentifier: "fpc_park") as? ParkViewController
        else {
            return
        }
        
        fpc.set(contentViewController: parkVC)
        fpc.addPanel(toParent: self)
    }
    
//    func hideFP() {
//        let fpc = FloatingPanelController()
//        fpc.hide(animated: true)
//    }

    
    func isLocationServiceEnabled() -> Bool {
        
        return CLLocationManager.locationServicesEnabled()
    }

    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
//            mapView.showsUserLocation = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
//            mapView.showsUserLocation = true
            break
        case .denied:
            showAlert(msg: "Location services required")
            break
        case .restricted:
            showAlert(msg: "Authorization restricted!")
            break
        default:
            print("default ..")
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("location: \(location.coordinate)")
            zoomToUserLocation(location: location)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func zoomToUserLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .denied:
            showAlert(msg: "Location services required")
            break
        default:
            print("default ..")
            break
        }
    }

    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    

}
