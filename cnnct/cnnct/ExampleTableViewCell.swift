//
//  ExampleTableViewCell.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/28/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit

class ExampleTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    func apply(_ image: UIImage) {
        contentImageView.image = image
    }
}
