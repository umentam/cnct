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
        let interestsController = storyboard.instantiateViewController(withIdentifier: "InterestsViewController")
        //productsViewController.type = .products
        
        let attendeesViewController = PeopleTableViewController()
        //venuesViewController.type = .venues
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
//        let reviewsViewController = StubContentTableViewController()
//        reviewsViewController.type = .reviews

        let messagesViewController = MessagesTableViewController()
//        let usersViewController = StubContentTableViewController()
//        usersViewController.type = .users
        
        //return [productsViewController, venuesViewController, reviewsViewController, usersViewController]
        return [interestsController, attendeesViewController,messagesViewController, profileViewController]
    }()
    
}
