//
//  LoginViewController.swift
//  chitchat
//
//  Created by Hajrudin Imamovic on 16/02/2025.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Toast_Swift

class LoginViewController : UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Any personalisation code
        
    }
    
    func handleFirebaseLogInError(error: Error) {
        if let authError = error as? NSError, authError.domain == AuthErrorDomain, authError.code == AuthErrorCode.invalidCredential.rawValue {
            if let userInfo = authError.userInfo as? [String: Any],
               let errorMessage = userInfo[NSLocalizedDescriptionKey] as? String {
                // Use the errorMessage in your toast
                self.view.makeToast(
                    "Invalid Credentials",
                    duration: 2.0,
                    position: .top,
                    title: "Error"
                ) // Assuming 'self.view' is available
            } else {
                // Fallback if error message extraction fails
                self.view.makeToast(
                    "Invalid Credentials",
                    duration: 2.0,
                    position: .top,
                    title: "Error"
                )
            }

        } else {
            // Handle other Firebase errors or general errors
            self.view.makeToast("An error occurred during signup.")
            print("Firebase signup error: \(error)") // Log the error for debugging
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password){authResult, error in
                if let e = error {
                    print(e)
                    self.handleFirebaseLogInError(error: e)
                } else {
                    self.view.makeToast(
                        "Logged in",
                        duration: 2.0,
                        position: .top
                    )
                    self.performSegue(withIdentifier: "loginToApp", sender: self)
                }
                
            }
        }

    }
}
