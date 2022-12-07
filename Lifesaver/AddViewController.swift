//
//  AddViewController.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 3.12.2022.
//

import UIKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var problemTextField: UITextField!
    @IBOutlet weak var dogImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        dogImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickedImage))
        dogImageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func pickedImage () {
        let selectedImage = UIImagePickerController()
        selectedImage.delegate = self
        selectedImage.allowsEditing = true
        selectedImage.sourceType = .photoLibrary
        self.present(selectedImage, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dogImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    @IBAction func nextButton(_ sender: Any) {
        
        if genderTextField.text != "" && typeTextField.text != "" && problemTextField.text != "" {
            if let dogChoosenImage = dogImageView.image {
                let lifesaverModel = Lifesaver.sharedInstance
                lifesaverModel.dogGender = self.genderTextField.text!
                lifesaverModel.dogType = self.typeTextField.text!
                lifesaverModel.dogProblem = self.problemTextField.text!
                lifesaverModel.dogImage = dogChoosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }else {
            self.makeAlert(title: "Error", message: "You need to fill in the blank fields.")
        }
        
    }
    
    func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }
    



}
