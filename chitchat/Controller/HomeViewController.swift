//
//  ViewController.swift
//  chitchat
//
//  Created by Hajrudin Imamovic on 16/02/2025.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.tintColor = .white
         
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toLoginScreen", sender: self)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRegisterScreen", sender: self)
    }
    
}

