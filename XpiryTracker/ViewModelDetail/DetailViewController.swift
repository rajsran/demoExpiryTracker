//
//  DetailViewController.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 8/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    private var productManager = ProductManager.shared
    
    var selectedRow : AllProductsViewModel.pModel?
    
    private var entries : [Entry] = []
    
    @IBOutlet weak var pName: UILabel!
    
    
    @IBOutlet weak var pImage: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath)
        
        
        let qty = cell.viewWithTag(20) as! UITextField
        qty.text = "Quantity Remaining " + String(entries[indexPath.row].quantity)
        
        let exp = cell.viewWithTag(10) as! UILabel
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        exp.text = "Expiring on: " + dateFormatter.string(from: entries[indexPath.row].expiryDt! as Date)
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        scrollView.touchesShouldCancel(in: tableView)
        
        if let selectedRow = selectedRow{
            pName.text = selectedRow.pName
            pImage.image = selectedRow.pImage
            entries = selectedRow.entry
            tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //entries = selectedRow!.entry
        let p = self.productManager.findProductWithName(name: self.selectedRow!.pName) as! Product
        self.entries = p.entries?.allObjects as! [Entry]
        var ents = self.entries.sorted(by: { $0.expiryDt!.compare($1.expiryDt! as Date)  == .orderedAscending })
        var x : [Entry] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = Date()
        let s = dateFormatter.string(from: today)
        let t = dateFormatter.date(from: s)
        
        for e in ents{
            if (e.quantity>0 && t!<=e.expiryDt as! Date){
                x.append(e)
            }
        }
        self.entries = x
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        performSegue(withIdentifier: "editSegue", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "editSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedRowIndex = self.tableView.indexPathForSelectedRow else {return}
        
        let destination = segue.destination as? EditEntryViewController
        
        destination?.product = selectedRow
        destination?.selectedEntry = selectedRowIndex.row
    }

    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completionHandler) in
            let entryToRemove = self.selectedRow?.entry[indexPath.row]
            
            self.productManager.removeEntry(product: self.productManager.findProductWithName(name: self.selectedRow!.pName) as! Product, entry: entryToRemove!)
            
            let p = self.productManager.findProductWithName(name: self.selectedRow!.pName) as! Product
            self.entries = p.entries?.allObjects as! [Entry]
            var ents = self.entries.sorted(by: { $0.expiryDt!.compare($1.expiryDt! as Date)  == .orderedAscending })
            var x : [Entry] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let today = Date()
            let s = dateFormatter.string(from: today)
            let t = dateFormatter.date(from: s)
            
            for e in ents{
                if (e.quantity>0 && t!<=e.expiryDt as! Date){
                    x.append(e)
                }
            }
            self.entries = x
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completionHandler) in
            let entryToRemove = self.selectedRow?.entry[indexPath.row]
            
            self.productManager.removeEntry(product: self.productManager.findProductWithName(name: self.selectedRow!.pName) as! Product, entry: entryToRemove!)
            
            let p = self.productManager.findProductWithName(name: self.selectedRow!.pName) as! Product
            self.entries = p.entries?.allObjects as! [Entry]
            var ents = self.entries.sorted(by: { $0.expiryDt!.compare($1.expiryDt! as Date)  == .orderedAscending })
            var x : [Entry] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let today = Date()
            let s = dateFormatter.string(from: today)
            let t = dateFormatter.date(from: s)
            
            for e in ents{
                if (e.quantity>0 && t!<=e.expiryDt as! Date){
                    x.append(e)
                }
            }
            self.entries = x
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }

}
