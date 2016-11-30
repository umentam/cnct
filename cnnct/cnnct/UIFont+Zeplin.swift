//
//  UIFont+Zeplin.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/28/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//


import UIKit

extension UIFont {
    
    class func navigationTitleFont() -> UIFont? {
        return UIFont(name: "GothamPro-Black", size: 20.0)
    }
    
    class func cellTitleFont() -> UIFont? {
        return UIFont(name: "GothamPro-Medium", size: 18.0)
    }
    
    class func menuTitleFont() -> UIFont? {
        return UIFont(name: "GothamPro", size: 15.0)
    }
    
    class func cellSubtitleFont() -> UIFont? {
        return UIFont(name: "GothamPro-Medium", size: 12.0)
    }
    
}