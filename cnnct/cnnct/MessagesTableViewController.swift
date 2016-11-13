//
//  MessagesTableViewController.swift
//  cnnct
//
//  Created by Michael Umenta on 11/12/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
    
    var ref = FIRDatabaseReference()
    var attendees : [FIRDataSnapshot] = []
    var interimUserIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        retrieveEventAttendees(completion: { (downLoadState) in
            downLoadState
        })
        
        self.navigationController?.navigationBar.topItem?.title = "Messages"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0),NSFontAttributeName:UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //#warning Incomplete implementation, return the number of sections
        //return 1
        var numOfSections: Int = 0
        if attendees.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections                = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text             = "Not matched with any attendees. Go Match!"
            noDataLabel.textColor        = UIColor.black
            noDataLabel.textAlignment    = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("I was touched!")
////        var snap:FIRDataSnapshot
////        snap = orgs[indexPath.row]
////        let controller = OrgProfileViewController()
////        controller.orgId = snap.key
////        self.navigationController?.pushViewController(controller, animated: true)
//    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return attendees.count
    }
    
    func retrieveEventAttendees(completion : (Bool) ->()) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("Users").child(userID!).child("matchees").observeSingleEvent(of: .value, with: { (snapshot) in
            for object in snapshot.children.allObjects as? [FIRDataSnapshot] ?? []{
                self.interimUserIds.append(object.key)
            }
            for object in self.interimUserIds {
                let attendeesQuery = self.ref.child("Users").child(object)
                attendeesQuery.observeSingleEvent(of: FIRDataEventType.value, with: {(snapshot)in
                    self.attendees.append(snapshot)
                    self.tableView.reloadData()
                })
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        completion(true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as! MessagesTableViewCell
        
        //Fetches appropriate info for each followed org
        var item : FIRDataSnapshot
        item = self.attendees[indexPath.row]
        
        //cell.orgNameLabel?.text = (item.value!["orgName"] as? String)
        cell.fullName?.text = (item.childSnapshot(forPath: "name").value as! String)
        cell.roleLabel?.text = (item.childSnapshot(forPath: "role").value as! String)
        
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
