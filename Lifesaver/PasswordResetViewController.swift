//
//  PasswordResetViewController.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 3.12.2022.
//

import UIKit
import Parse

class PasswordResetViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func PasswordResetButton(_ sender: Any) {
        if emailTextField.text != "" {
            PFUser.requestPasswordResetForEmail(inBackground: emailTextField.text!) { isDone, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                }else {
                    self.makeAlertwithAction(title: "Completed", message: "We have sent an password reset email. Check you mailbox")
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
