//
//  ControllersProvider.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/28/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import ColorMatchTabs

class StubContentViewControllersProvider {
    
    static let viewControllers: [UIViewController] = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InterestsViewController")
        let productsViewController = controller
        //productsViewController.type = .products
        
        let attendeesViewController = PeopleTableViewController()
        //venuesViewController.type = .venues
        
//        let reviewsViewController = StubContentTableViewController()
//        reviewsViewController.type = .reviews
//        
//        let usersViewController = StubContentTableViewController()
//        usersViewController.type = .users
        
        //return [productsViewController, venuesViewController, reviewsViewController, usersViewController]
        return [productsViewController, attendeesViewController]
    }()
    
}
