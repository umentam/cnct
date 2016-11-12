//
//  ProfileViewController.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/12/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.topItem?.title = "Your Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0),NSFontAttributeName:UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(_ sender: Any) {
        FBSDKLoginManager().logOut()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
