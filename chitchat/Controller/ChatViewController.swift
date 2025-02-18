//
//  ChatViewController.swift
//  chitchat
//
//  Created by Hajrudin Imamovic on 16/02/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

// MARK: Main Class Functions & Setup
class ChatViewController : UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    // To use the cloud firestore from Firebase, the database must be initialised
    let db = Firestore.firestore()
    
    // This array keeps the messages from the firestore
    // Initially, these three messages are there just as placeholders
    var messages : [Message] = [
        Message(sender: "hajro@gmail.com", body: "Hey man whats up?"),
        Message(sender: "1@2.com", body: "Nothing much, just finished my workout!"),
        Message(sender: "hajro@gmail.com", body: "Sweeet, nice work man!")
    ]
    
    // The things to run when the view is loaded (view lifecylce)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // These two lines change the navigation items
        // Those basically include the status bar at the top
        navigationItem.hidesBackButton = true // Hides the back button only for this specific view controller
        navigationItem.title = "ChitChat" // Give the status bar a title
        
        // This function is related to the message text field and the keyboard module
        // They are related to the extension at the bottom, which will
        hideKeyboardWhenSwipedDown()
        
        // To use this class as the datasource of the text field and the
        // message text field delegate, we set both to be this class (self)
        tableView.dataSource = self
        messageTextField.delegate = self
        
        // To make the custom cell available to the table view,
        // we have to register the custom table view cell we created to it
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        
        // Upon loading the view, the messages will get loaded
        loadMessages()
    }
    
    // Lodaing the messages from the firestore
    func loadMessages(){
        db.collection("messages") // From the messages collection...
            .order(by: "date")  //...order all the results by date...
            .addSnapshotListener { querySnapshot, error in //.. and add a constant listener for changes that will do the following code:
                self.messages = [] // Empty the array initially,
                
                if let e = error {
                    print("There was an error retrieving data from firestore, \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents { //If there are any documents inside the snapshot, retrieve them into the snapshotDocuments variable...
                        for document in snapshotDocuments { //... and for each of those document...
                            let data = document.data() //...grab the data and create a Message.
                            
                            if let sender = data["sender"] as? String, let message = data["message"] as? String {
                                let message = Message(sender: sender, body: message)
                                
                                self.messages.append(message) // Append the message to the message array...
                                
                                DispatchQueue.main.async { // ...then, on the MAIN thread, reload the data and scroll down to the botom.
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    // Logging out of the application and firebase session
    @IBAction func logOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut() // Try to sign out, if already signed in...
            navigationController?.popToRootViewController(animated: true) // ... then pop back to the root view controller, that is the HomeScreen
        } catch let error as NSError {
            print(error)
        }
    }
    
    // Sending a message to the database
    @IBAction func sendPressed(_ sender: UIButton) {
        if let message = messageTextField.text, message.isEmpty == false, let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: [
                "sender" : messageSender,
                "message" : message,
                "date" : Date().timeIntervalSince1970
            ]) { error in
                if let e = error{
                    print(e)
                    print("ERROR WHILE SENDING MESSAGE TO FIREBASE")
                } else {
                    print("Data sent succesfully")
                    
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                }
            }
        }
    }
}

// MARK: Table View Data Source Functions
extension ChatViewController : UITableViewDataSource {
    // This method returns the number of rows for the actual table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    // This methods provides a cell object for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the first message from the Row or the database
        let message = messages[indexPath.row]
        
        // Creating the cell as a Message Cell for that message
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        cell.messageText.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.rightImageView.isHidden = false
            cell.leftImageView.isHidden = true
            cell.messageBody.backgroundColor = UIColor(named: "TonesSecondary")
        } else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBody.backgroundColor = UIColor(named: "Background")
        }
        
        return cell
    }
}

// MARK: Text Field Delegate Methods
extension ChatViewController : UITextFieldDelegate {
    func hideKeyboardWhenSwipedDown() {
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendPressed(sendMessageButton)
        return true
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
     }
}
