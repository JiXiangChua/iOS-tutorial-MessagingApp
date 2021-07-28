//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by JI XIANG on 14/7/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() { //function executed when we create a new message cell
        super.awakeFromNib()
        
        // Initialization code
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5 //corner radius to change with the height dynamically
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
