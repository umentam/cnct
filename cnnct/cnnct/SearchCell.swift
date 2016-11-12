//
//  SearchCell.swift
//  cnnct
//
//  Created by Gabriel Wamunyu on 11/12/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import Foundation

class SearchCell: UITableViewCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        self.initialize()
    }
    
    func initialize(){
        self.selectedBackgroundView = self.customView()
    }
    
    func customView()->UIView{
        
        return UIView.init(frame: self.bounds)
        
        
    }
}
