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

class ChatViewController : UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages : [Message] = [
        Message(sender: "hajro@gmail.com", body: "Hey man whats up?"),
        Message(sender: "1@2.com", body: "Nothing much, just finished my workout!"),
        Message(sender: "hajro@gmail.com", body: "Sweeet, nice work man!")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Any personalisation code
    
        navigationItem.hidesBackButton = true
        navigationItem.title = "ChitChat"
        
        tableView.dataSource = self
        
        // To make the cell available to the table view, we have to register the custom
        // table view cell we created to it
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        
    }
    @IBAction func logOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        
    }
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
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
