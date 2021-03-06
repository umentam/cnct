//
//  FirstViewController.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/11/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit

class InterestsViewController: UIViewController {
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tagListView: UIView!
    var newTagListView:TagListView!
    var mainSet:Set<String> = Set([])
    var tagsDict = [String:Int]()
    var eventID:String = ""
    var prefTags = [String]()
    var ref:FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        self.extendedLayoutIncludesOpaqueBars = true;
        self.edgesForExtendedLayout = [];
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view.
        newTagListView = TagListView(frame: CGRect(0, 0 , self.view.frame.size.width,tagListView.frame.size.height))
        self.view.addSubview(newTagListView)
        newTagListView.backgroundColor = UIColor.white
        newTagListView.layer.borderColor = UIColor.white.cgColor
        newTagListView.layer.borderWidth = 0.2
        
        updateButton.backgroundColor = UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        updateButton.layer.cornerRadius = updateButton.frame.size.height / 2;
        
        //updateButton.isHidden = true
        updateButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        //updateButton.titleLabel?.font = UIFont.cellTitleFont()
        
        //updateButton.setImage(UIImage(named: "update"), for: UIControlState.normal)
        
        
        let eventTagsQuery = self.ref.child("Events").queryLimited(toFirst: 100)
        
        
        eventTagsQuery.queryOrderedByKey().observeSingleEvent(of: FIRDataEventType.value, with: {(snapshot) in
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                //eventID = rest.key
                print (rest.key)
                if (rest.key == "-KfFBuFfhV83rwn4fMd8") {
                    let newQuery = self.ref.child("Events").child(rest.key).child("eventTags")
                    newQuery.queryOrderedByKey().observeSingleEvent(of: FIRDataEventType.value, with: {(snapshot) in
                        self.tagsDict = snapshot.value as! [String : Int]
                        print(self.tagsDict)
                        
                        for newRest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                            self.prefTags.append(newRest.key)
                        }
                        for (index,i) in self.prefTags.enumerated()
                        {
                            let color:UIColor!
                            if index%4 == 1
                            {
                                color = UIColor(red: 238/255, green: 101/255, blue: 107/255, alpha: 1)
                            }
                            else if index%4 == 2
                            {
                                color = UIColor(red: 96/255, green: 95/255, blue: 132/255, alpha: 1)
                            }
                            else if index%4 == 3
                            {
                                color = UIColor(red: 85/255, green: 152/255, blue: 158/255, alpha: 1)
                            }
                            else
                            {
                                color = UIColor(red: 184/255, green: 205/255, blue: 158/255, alpha: 1)
                            }
                            
                            let finalText = self.tagsDict[i]
                            
                            let mainText = " \(i) (\(finalText!))"
                            self.newTagListView.addTag(text: mainText, target: self, tapAction: #selector(self.tap(sender:)), backgroundColor: color, textColor: UIColor.white)
                        }
                    })
                }
                
                
            }
        })
    }
    
    //Method to ensure you have deselected.
    func getRandomColor() -> UIColor  {
        let randomNumber = Int(arc4random_uniform(5) + 1)
        let color:UIColor!
        if randomNumber == 1
        {
            color = UIColor(red: 238/255, green: 101/255, blue: 107/255, alpha: 1)
        }
        else if randomNumber == 2
        {
            color = UIColor(red: 96/255, green: 95/255, blue: 132/255, alpha: 1)
        }
        else if randomNumber == 3
        {
            color = UIColor(red: 85/255, green: 152/255, blue: 158/255, alpha: 1)
        }
        else
        {
            color = UIColor(red: 184/255, green: 205/255, blue: 158/255, alpha: 1)
        }
        return color
        
    }
    
   
    @IBAction func updateClicked(_ sender: Any) {
        
       // ExampleViewContoller().selectItem(at: 1)
//        myCont.selectItem(at:0);
        
        if !(mainSet.isEmpty) {
            let preferences = mainSet
            
            //let userCurrent = FBSDKAccessToken.current()
            let userID = FIRAuth.auth()?.currentUser?.uid
            
//            for object in self.tagsDict {
//                self.ref.child("Events").child(self.eventID).child("eventTags").updateChildValues([object:true])
//                
//            }
            
            for object in preferences {
                self.ref.child("Users").child(userID!).child("preferences").updateChildValues([object:true])
            }
            let myAlertController = UIAlertController(title: "Updated!", message:
                nil, preferredStyle: UIAlertControllerStyle.alert)
            self.present(myAlertController, animated: true, completion: { () -> Void in
                myAlertController.dismiss(animated: true, completion:nil)
            })

        }
        else {
            let alertController = UIAlertController(title: "Hi :)", message:
                "Please pick some tags for us to better understand who to connect you with.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
            }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func tap (sender:UITapGestureRecognizer)
    {
        //updateButton.isHidden = false
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.updateButton.transform = .identity
            },
                       completion: nil)
        let label = (sender.view as! UILabel)
        let textToInsert = label.text!
        
        if(label.backgroundColor != UIColor.lightGray) {
            mainSet.insert(textToInsert)
            label.backgroundColor = UIColor.lightGray
        } else {
            mainSet.remove(textToInsert)
            label.backgroundColor = getRandomColor()
        }
        
    }
    
    
}
