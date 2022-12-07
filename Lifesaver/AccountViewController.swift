//
//  AccountViewController.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 3.12.2022.
//

import UIKit
import Parse

class AccountViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.current()
        if let id = user?.objectId as? String {
            let query = PFQuery(className: "ProfilePictures")
            query.whereKey("fileName", equalTo: "\(id)")
            query.findObjectsInBackground { objects, error in
                if error != nil{
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                }else{
                    if objects != nil {
                        if let choosenImage = objects![0].object(forKey: "picture") as? PFFileObject {
                            choosenImage.getDataInBackground { data, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                                }else{
                                    self.profileImageView.image = UIImage(data: data!)
                                    self.usernameTextField.text = user?.username
                                    self.emailTextField.text = user?.email
                                    
                                }
                            }
                        }
                    }

                }
            }
        } 
        
    }

    
    @IBAction func logOutButton(_ sender: Any) {
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
            }else {
                self.performSegue(withIdentifier: "toHomeVC", sender: nil)
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
