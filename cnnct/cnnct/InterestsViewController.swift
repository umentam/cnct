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

class InterestsViewController: UIViewController {
    
    @IBOutlet weak var tagListView: UIView!
    var newTagListView:TagListView!
    var mainSet:Set<String> = Set([])
    var prefTags = [String]()
    var ref:FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.topItem?.title = "Pick Your Event Interests"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0),NSFontAttributeName:UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)]
        
        
        // Do any additional setup after loading the view.
        newTagListView = TagListView(frame: CGRect(0, tagListView.frame.minY , self.view.frame.size.width,tagListView.frame.size.height))
        self.view.addSubview(newTagListView)
        newTagListView.backgroundColor = UIColor.white
        newTagListView.layer.borderColor = UIColor.white.cgColor
        newTagListView.layer.borderWidth = 0.2
        
        updateButton.backgroundColor = UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        //updateButton.setImage(UIImage(named: "update"), for: UIControlState.normal)
        
        
        let eventTagsQuery = self.ref.child("Events").queryLimited(toFirst: 100)
        
        
        eventTagsQuery.queryOrderedByKey().observeSingleEvent(of: FIRDataEventType.value, with: {(snapshot) in
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let newQuery = self.ref.child("Events").child(rest.key).child("eventTags")
                newQuery.queryOrderedByKey().observeSingleEvent(of: FIRDataEventType.value, with: {(snapshot) in
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
                        self.newTagListView.addTag(text: i, target: self, tapAction: #selector(self.tap(sender:)), backgroundColor: color, textColor: UIColor.white)
                        
                    }
                })
                
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func tap (sender:UITapGestureRecognizer)
    {
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
