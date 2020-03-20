//
//  ViewController.swift
//  Locations Client
//
//  Created by rb on 6/18/19.
//  Copyright © 2019 premBhanderi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text, username.count > 0, password.count > 0 else {
            return
        }
        APIClient.register(withUsername: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        guard let username = usernameTextField?.text, let password = passwordTextField?.text, username.count > 0, password.count > 0 else {
            return
        }
        
        APIClient.login(withUsername: usernameTextField.text!, password: passwordTextField.text!, completion: {
            if UserDefaults.standard.string(forKey: "access_token") != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "GroupsViewController") as! GroupsViewController
                self.present(controller, animated: true, completion: nil)
            }
        })
        
    }
}


