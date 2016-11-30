//
//  ProfileViewController.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/12/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit


class ProfileViewController: UIViewController {
    
    
    var userName : String = ""
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var usernameTextView: UITextView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var backgroundTextView: UITextView!
    
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.topItem?.title = "Your Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0),NSFontAttributeName:UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)]
        createEventButton.layer.cornerRadius = 8.0
        ref = FIRDatabase.database().reference()
        
        fetchFBUserInformation()
        fetchFirebaseUserInformation()
    }
    
    func fetchFirebaseUserInformation(){
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as! [String:Any]
            self.roleLabel.text = (values["role"] as? String)!
            self.backgroundTextView.text = (values["background"] as? String)!
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func fetchFBUserInformation(){
        
        if((FBSDKAccessToken.current()) != nil){
            
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "me", parameters: nil)
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    // Process error
                    print("Error: \(error)")
                }
                else
                {
                   
                    
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    self.userName = (data["name"] as? String)!
                    
                    
                   
                    
                    let userID = data["id"] as! NSString
                   
                    let facebookProfileUrl = "https://graph.facebook.com/\(userID)/picture?type=large"
                    let url = URL(string: facebookProfileUrl)
                    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.width / 2
                    self.profilePicImageView.clipsToBounds = true
                    
                    if let imageData = NSData(contentsOf: url!) as? Data{
                        self.profilePicImageView.image = UIImage(data: imageData)
                    }else{
                        print("no image data")
                    }
                    
                    self.usernameTextView.text = self.userName
 
                    
                    //   self.userEmail = result.valueForKey("email") as? String
                    
                }
            })
        }
    }
    
    @IBAction func createEvent(_ sender: AnyObject) {
        print("THE USER IS TRYING TO CREATE AN EVENT!!!")
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
