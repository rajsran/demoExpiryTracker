//
//  WastageViewController.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 9/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import UIKit

class WastageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var wastedProducts : [WastageViewModel.pModel] = []
    
    private var viewModel = WastageViewModel()
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var startDate: UITextField!
    
    @IBOutlet weak var endDate: UITextField!
    
    @IBAction func onEditStartDate(_ sender: Any) {
        if (endDate.text == ""){
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let date1 = dateFormatter.date(from:startDate.text!)
        let date2 = dateFormatter.date(from:endDate.text!)
        let today = Date()
        
        if (date1! >= today || date2! >= today){
            msg.numberOfLines = 2
            msg.lineBreakMode = .byWordWrapping
            msg.text = "Please Choose dates from past"
            msg.sizeToFit()
            wastedProducts = []
            tableView.reloadData()
        }
        
        else if (date2! < date1!){
            msg.numberOfLines = 2
            msg.lineBreakMode = .byWordWrapping
            msg.text = "Please choose end date after start date"
            msg.sizeToFit()
            wastedProducts = []
            tableView.reloadData()
        }
        
        else{
            wastedProducts = viewModel.getWastedProduct(date1!, date2!)
            tableView.reloadData()
            if (wastedProducts.count == 0){
                msg.numberOfLines = 2
                msg.lineBreakMode = .byWordWrapping
                msg.text = "No products wasted in this time range"
                msg.sizeToFit()
            }
            else{
                msg.text = ""
            }
        }
        
    }
    
    @IBAction func onEditEndDate(_ sender: Any) {
        if (startDate.text == ""){
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let date1 = dateFormatter.date(from:startDate.text!)
        let date2 = dateFormatter.date(from:endDate.text!)
        let today = Date()
        
        if (date1! > today || date2! > today){
            msg.numberOfLines = 2
            msg.lineBreakMode = .byWordWrapping
            msg.text = "Please Choose dates from past"
            msg.sizeToFit()
            wastedProducts = []
            tableView.reloadData()
        }
            
        else if (date2! < date1!){
            msg.numberOfLines = 2
            msg.lineBreakMode = .byWordWrapping
            msg.text = "Please choose end date after start date"
            msg.sizeToFit()
            wastedProducts = []
            tableView.reloadData()
        }
            
        else{
            wastedProducts = viewModel.getWastedProduct(date1!, date2!)
            tableView.reloadData()
            if (wastedProducts.count == 0){
                msg.numberOfLines = 2
                msg.lineBreakMode = .byWordWrapping
                msg.text = "No products wasted in this time range"
                msg.sizeToFit()
            }
            else{
                msg.text = ""
            }
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var msg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        createDatePicker2()
        
        tableView.rowHeight = 80
        
        msg.numberOfLines = 0
        msg.lineBreakMode = .byWordWrapping
        msg.sizeToFit()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        startDate.text = ""
        endDate.text = ""
        wastedProducts = []
        tableView.reloadData()
        msg.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wastedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        
        let img = cell.viewWithTag(10) as! UIImageView
        img.image = wastedProducts[indexPath.row].pImage
        
        let title = cell.viewWithTag(20) as! UILabel
        title.text = "Product name: " + wastedProducts[indexPath.row].pName
        
        let qty = cell.viewWithTag(30) as! UILabel
        qty.text = "quantity Wasted: " + String(wastedProducts[indexPath.row].qty)
        return cell
    }
    
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed1))
        toolBar.setItems([done], animated: true)
        
        startDate.inputAccessoryView = toolBar
        
        startDate.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed1(){
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var s = dateFormatter.string(from: datePicker.date)
        startDate.text = s
        self.view.endEditing(true)
    }
    
    func createDatePicker2(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
        toolBar.setItems([done], animated: true)
        
        endDate.inputAccessoryView = toolBar
        
        endDate.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed2(){
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var s = dateFormatter.string(from: datePicker.date)
        endDate.text = s
        self.view.endEditing(true)
    }

}
