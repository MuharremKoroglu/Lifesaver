//
//  ViewController.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 3.12.2022.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func SignInButton(_ sender: Any) {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { user, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went worng")
                }else{
                    self.performSegue(withIdentifier: "toMainVC" , sender: nil)
                }
            }
        }else{
            makeAlert(title: "Error", message: "Username and Password cannot be empty!")
        }
        
    }
    
    @IBAction func PasswordResetButton(_ sender: Any) {
        performSegue(withIdentifier: "toPasswordResetVC", sender: nil)
    }
    
    
    @IBAction func SignUpButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }
    

}

