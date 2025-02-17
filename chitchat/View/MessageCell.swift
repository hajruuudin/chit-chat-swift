//
//  MessageCell.swift
//  chitchat
//
//  Created by Hajrudin Imamovic on 17/02/2025.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var messageBody: UIView!
    @IBOutlet weak var messageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageBody.layer.cornerRadius = messageBody.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
