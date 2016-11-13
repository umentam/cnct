//
//  SkillsViewController.swift
//  cnnct
//
//  Created by Michael Umenta on 11/12/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit

class SkillsViewController: UIViewController {
    
    @IBOutlet weak var roleField: UITextField!
    
    var ref:FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRApp.configure()
        ref = FIRDatabase.database().reference()
        self.navigationController?.navigationBar.topItem?.title = "Your Role"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0),NSFontAttributeName:UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)]
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoSearch(_ sender: AnyObject) {
        print("he wants to perform a segue")
        let role = roleField.text
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        self.ref.child("Users").child(userID!).child("role").setValue(role)
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as UIViewController
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true, completion: nil)
    }
    
}
