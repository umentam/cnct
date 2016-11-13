//
//  SignUpViewController.swift
//  cnnct
//
//  Created by Michael Umenta on 11/12/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate{

    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var accountCreationIndicator: UIActivityIndicatorView!
    @IBOutlet weak var schoolChoice: UITextField!
    
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        var loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = self.view.center
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.view.addSubview(loginButton)
        
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print("user is already logged in")
            
        }
        else {
    
        }
        
    }
    
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            print("Had an error loggin in")
            return
        }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            print("Logged in successfully!")
            
            let defaults = UserDefaults.standard
            if(defaults.bool(forKey: "hasSignedUp")){
                self.gotoInterestsView()
            }
            else {
                let accessToken = FBSDKAccessToken.current()
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields":"email,name"])
                graphRequest?.start { [weak self] connection, result, error in
                    if error != nil {
                        //onError()
                        
                        print(error)
                        return
                    }else{
                        var data = result as! [String:Any]
                        var fbID = data["id"]!
                        let facebookProfileUrl = "https://graph.facebook.com/\(fbID)/picture?type=large"
                        print(data)
                        print("printing the fb data")
                        self?.ref.child("Users").child((user?.uid)!).updateChildValues(["name": data["name"]!, "email": data["email"]!, "facebookID": fbID, "facebookProfileUrl": facebookProfileUrl])
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "hasSignedUp")
                        
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SkillsViewController") as UIViewController
                        let navController = UINavigationController(rootViewController: viewController)
                        self?.present(navController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func gotoInterestsView(){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InterestsViewController") as UIViewController
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true, completion: nil)

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
