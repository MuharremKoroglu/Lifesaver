//
//  DetailsViewController.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 4.12.2022.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var problemTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenID = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        getDataFromParse()
    }
    
    func getDataFromParse () {
        
        let query = PFQuery(className: "DogInfo")
        query.whereKey("objectId", equalTo: chosenID)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
            }else{
                if objects != nil {
                    let choosenObject = objects![0]
                    
                    if let gender = choosenObject.object(forKey: "dog_gender") as? String {
                        self.genderTextField.text = gender
                    }
                    if let type = choosenObject.object(forKey: "dog_type") as? String {
                        self.typeTextField.text = type
                    }
                    if let problem = choosenObject.object(forKey: "dog_problem") as? String {
                        self.problemTextField.text = problem
                    }
                    if let latitude = choosenObject.object(forKey: "dog_latitude") as? String {
                        if let latitudeDouble = Double(latitude) {
                            self.chosenLatitude = latitudeDouble
                        }
                    }
                    if let longitude = choosenObject.object(forKey: "dog_longitude") as? String {
                        if let longitudeDouble = Double(longitude) {
                            self.chosenLongitude = longitudeDouble
                        }
                    }

                    if let image = choosenObject.object(forKey: "dog_image") as? PFFileObject {
                        image.getDataInBackground { data, error in
                            if error != nil {
                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                            }else {
                                if data != nil {
                                    self.dogImageView.image = UIImage(data: data!)
                                }
                            }
                        }
                    }
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.mapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.typeTextField.text!
                    annotation.subtitle = self.problemTextField.text!
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "newAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                }else {
                    if let placemark = placemarks {
                        if placemark.count > 0 {
                            
                            let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                            let mapItem = MKMapItem(placemark: mkPlaceMark)
                            mapItem.name = self.typeTextField.text!
                            let launchingOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                            mapItem.openInMaps(launchOptions: launchingOptions)
                        }
                    }
                }
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
