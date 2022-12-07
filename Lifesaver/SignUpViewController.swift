//
//  SignUpViewController.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 3.12.2022.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        profileImageView.addGestureRecognizer(gestureRecognizer)

    }
    
    @objc func chooseImage () {
        let choosenImage = UIImagePickerController()
        choosenImage.delegate = self
        choosenImage.allowsEditing = true
        choosenImage.sourceType = .photoLibrary
        present(choosenImage, animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        
        if userNameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" {
                let user = PFUser()
                user.username = userNameTextField.text!
                user.email = emailTextField.text!
                user.password = passwordTextField.text!
                user.signUpInBackground {  isDone, error in
                    if error != nil {
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                    }else {
                        let userProfilePictureData = PFObject(className: "ProfilePictures")
                        userProfilePictureData["fileName"] = PFUser.current()?.objectId
                        if let choosenImage = self.profileImageView.image?.jpegData(compressionQuality: 0.5) {
                            userProfilePictureData["picture"] = PFFileObject(name: "\(user.objectId!).jpg", data: choosenImage)
                            userProfilePictureData.saveInBackground { isDone, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                                }else{
                                    PFUser.logOutInBackground { error in
                                        if error != nil {
                                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                                        }else{
                                            self.makeAlertwithAction(title: "Verify", message: "Now, you need to verify your email. Check your mailbox")
                                        }
                                    }
                                }
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
    
    func makeAlertwithAction(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) { UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(button)
        present(alert, animated: true)
    }
    
    



}
