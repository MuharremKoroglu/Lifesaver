//
//  MapViewController.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 3.12.2022.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(annotation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func annotation (gestureRecognizer : UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedPointCoordinate = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            Lifesaver.sharedInstance.dogLatitude = String(touchedPointCoordinate.latitude)
            Lifesaver.sharedInstance.dogLongitude = String(touchedPointCoordinate.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedPointCoordinate
            annotation.title = Lifesaver.sharedInstance.dogType
            annotation.subtitle = Lifesaver.sharedInstance.dogProblem
            self.mapView.addAnnotation(annotation)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    

    @IBAction func saveButton(_ sender: Any) {
        
        let lifeSaver = Lifesaver.sharedInstance
        let dogData = PFObject(className: "DogInfo")
        dogData["dog_gender"] = lifeSaver.dogGender
        dogData["dog_type"] = lifeSaver.dogType
        dogData["dog_problem"] = lifeSaver.dogProblem
        dogData["dog_latitude"] = lifeSaver.dogLatitude
        dogData["dog_longitude"] = lifeSaver.dogLongitude
        
        if let userId = PFUser.current()?.objectId as? String {
            if let dogImage = lifeSaver.dogImage.jpegData(compressionQuality: 0.5) {
                dogData["dog_image"] = PFFileObject(name: "\(userId).jpg", data: dogImage)
            }
        }
        
        dogData.saveInBackground { isDone, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
            }else {
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            }
        }

        
    }
    
    func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }
    

}
