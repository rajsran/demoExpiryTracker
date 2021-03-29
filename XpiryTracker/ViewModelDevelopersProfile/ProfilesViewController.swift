//
//  ProfilesViewController.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 9/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import UIKit

var currList = ProfileDetailsTableViewController()

class ProfilesViewController: UIViewController {
    
    var str1 = ""
    var str2 = ""
    var str3 = ""
    
    @IBOutlet weak var label1: UILabel!
    
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        label1.text = str1
        label2.text = str2
        label3.text = str3
        
    }

}
