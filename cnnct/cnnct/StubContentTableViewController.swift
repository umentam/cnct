//
//  StubContentTableViewController.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/28/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit

class StubContentTableViewController: UITableViewController {

    enum `Type` {
        case products, venues, reviews, users
    }
    
    var type: Type!
    fileprivate var objects: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupDataSource()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor.clear
        tableView.allowsSelection = false
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib(nibName: "ExampleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    fileprivate func setupDataSource() {
        if type == .products || type == .reviews {
            self.objects = [UIImage(named: "product_card1")!, UIImage(named: "product_card2")!]
        } else if type == .venues || type == .users {
            self.objects = [UIImage(named: "venue_card1")!, UIImage(named: "venue_card2")!]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExampleTableViewCell
        let image = objects[(indexPath as NSIndexPath).row]
        cell.apply(image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width / 1.4
    }

}
