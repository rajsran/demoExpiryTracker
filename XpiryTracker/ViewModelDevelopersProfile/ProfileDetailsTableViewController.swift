//
//  ProfileDetailsTableViewController.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 9/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import UIKit

class ProfileDetailsTableViewController: UITableViewController {
    
    let details = DevelopersDetailsViewModel()
    var newData : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newData = details.newData
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "developerCell", for: indexPath)
        
        let name = cell.viewWithTag(10) as! UILabel
        name.text = newData[indexPath.row][0]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as! ProfilesViewController
        
        vc.str1 = "Student ID : " + newData[indexPath.row][1]
        vc.str2 = "Course : " + "\n" + newData[indexPath.row][2]
        vc.str3 = newData[indexPath.row][3]
        
        splitViewController?.showDetailViewController(vc, sender: nil)
    }

}
