//
//  TabSwitcherItemsProvider.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/28/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import ColorMatchTabs

class TabItemsProvider {
    
    static let items = {
        return [
            TabItem(
                title: "Interests",
                tintColor: UIColor(red: 0.51, green: 0.72, blue: 0.25, alpha: 1.00),
                normalImage: UIImage(named: "Price Tag")!,
                highlightedImage: UIImage(named: "Price Tag-unfilled")!
            ),
            TabItem(
                title: "Attendees",
                tintColor: UIColor(red: 0.15, green: 0.67, blue: 0.99, alpha: 1.00),
                normalImage: UIImage(named: "Conference")!,
                highlightedImage: UIImage(named: "Conference-unfilled")!
            )
        ]
    }()
    
}
