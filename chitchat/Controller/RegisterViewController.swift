//
//  RegisterViewController.swift
//  chitchat
//
//  Created by Hajrudin Imamovic on 16/02/2025.
//

import UIKit
import Toast_Swift
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class RegisterViewController : UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Any personalisation Functions
        
    }
    
    func handleFirebaseSignUpError(error: Error) {
        if let authError = error as? NSError, authError.domain == AuthErrorDomain, authError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
            if let userInfo = authError.userInfo as? [String: Any],
               let errorMessage = userInfo[NSLocalizedDescriptionKey] as? String {
                // Use the errorMessage in your toast
                self.view.makeToast(
                    errorMessage,
                    duration: 2.0,
                    position: .top,
                    title: "Error"
                ) // Assuming 'self.view' is available
            } else {
                // Fallback if error message extraction fails
                self.view.makeToast(
                    "Email already in use...",
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
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if !email.contains("@") {
                self.view.makeToast(
                    "Email needs to be in the right format...",
                    duration: 2.0,
                    position: .top,
                    title: "Email Error"
                )
                return
            }
            
            if password.count < 6 {
                self.view.makeToast(
                    "Password cannot be lower than six chars...",
                    duration: 2.0,
                    position: .top,
                    title: "Password Error"
                )
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    self.handleFirebaseSignUpError(error: e)
                } else {
                    self.view.makeToast(
                        "Registered \(email)",
                        duration: 2.0,
                        position: .bottom
                    )
                    self.performSegue(withIdentifier: "registerToApp", sender: self)
                    
                }
            }
        }
        

        
    }
}
