//
//  ViewController.swift
//  InstagramCloneFirebase
//
//  Created by Kadir Yılmaz on 8.01.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func signIn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdata, error in
            
            if error != nil {
                self.makeAlert(titleInput: "Error", messageIntput: error?.localizedDescription ?? "Error")
            }else{
                self.performSegue(withIdentifier: "toTabBarVC", sender: nil)
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdata, error in
            
            if error != nil {
                self.makeAlert(titleInput: "Error", messageIntput: error?.localizedDescription ?? "Error")
            }else{
                self.performSegue(withIdentifier: "toTabBarVC", sender: nil)
            }
        }
        
    }
    
    func makeAlert(titleInput: String, messageIntput: String){
        let alert = UIAlertController(title: titleInput, message: messageIntput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

