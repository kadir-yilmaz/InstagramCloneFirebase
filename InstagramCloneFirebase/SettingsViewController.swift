//
//  SettingsViewController.swift
//  InstagramCloneFirebase
//
//  Created by Kadir Yılmaz on 8.01.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toVC", sender: nil)
        } catch  {
            print("error")
        }
    }
    
    

}
