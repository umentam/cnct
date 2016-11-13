//
//  MessagesTableViewCell.swift
//  cnnct
//
//  Created by Michael Umenta on 11/12/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    //@IBOutlet weak var lastMessage: UILabel!
    
    @IBOutlet weak var lastMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
