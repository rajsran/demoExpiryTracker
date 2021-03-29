//
//  EditEntryViewController.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 8/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController {
    var product : AllProductsViewModel.pModel?
    var selectedEntry : Int = 0
    
    let datePicker = UIDatePicker()
    
    private var viewModel = EditEntryViewModel()
    
    @IBOutlet weak var pName: UITextField!
    
    @IBOutlet weak var st: UIStepper!
    
    @IBAction func stepper(_ sender: UIStepper) {
        sender.minimumValue = 0
        quantity.text = Int(sender.value).description
    }
    
    @IBOutlet weak var quantity: UITextField!
    
    @IBOutlet weak var expDt: UITextField!
    
    
    @IBAction func onEditExpDt(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dt1 = expDt.text
        if (dt1 == ""){
            return
        }
            
        else if(alertDt.text != ""){
            return
        }
            
        else{
            if let s = dateFormatter.date(from: dt1!){
                let alertDate = Calendar.current.date(byAdding: .day, value: -1, to: s)
                print(alertDate)
                
                let date = NSDate()
                var dateString = dateFormatter.string(from: alertDate!)
                alertDt.text = dateString
            }
            
        }

    }
    
    @IBOutlet weak var isAlert: UISwitch!
    
    @IBAction func onSwitch(_ sender: Any) {
        if (isAlert.isOn == false){
            alertDt.isEnabled = false
            alertDt.textColor = UIColor.white
        }
        else{
            alertDt.isEnabled = true
            alertDt.textColor = UIColor.black
        }
    }
    
    
    @IBOutlet weak var alertDt: UITextField!
    
    @IBOutlet weak var pImage: UIImageView!
    
    @IBAction func onUpdate(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var date1 : Date
        var date2 : Date
        
        guard let d1 = expDt.text else {
            return
        }
        
        if (d1==""){
            showAlert(msg: "plese select an expiry date", title: "ChangeExpiry Date")
            return
        }
        
        date1 = dateFormatter.date(from:d1)!
        
        guard let d2 = alertDt.text else {
            return
        }
        
        date2 = dateFormatter.date(from:d2)!
        let today = Date()
        
        if (today>date2  && isAlert.isOn){
            showAlert(msg: "Alert date has passed by", title: "Change Alert Date")
            return
        }
            
        else if (date2>date1  && isAlert.isOn){
            showAlert(msg: "Selected alert date is after expiry date", title: "Change Alert Date")
            return
        }
        
        let result = viewModel.changeEntry(pName.text!, product?.entry[selectedEntry].expiryDt as! Date, date1, date2, isAlert.isOn, Int(quantity.text!)!)
        
        
       
        if (result){
            showAlert(msg: "Entry has been updated.", title: "Success")
            msg.text = "Entry has been updated."
        }
        
        else{
            showAlert(msg: "Error occurred while updating entry.", title: "Error")
        }
        
    }
    
    
    @IBOutlet weak var msg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let product = product{
            pName.text = product.pName
            pImage.image = product.pImage
            let entries = product.entry
            let entry = entries[selectedEntry]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            expDt.text = dateFormatter.string(from: entry.expiryDt! as Date)
            quantity.text = String(entry.quantity)
            st.value = Double(entry.quantity)
            isAlert.isOn = entry.isAlert
            
            alertDt.text = dateFormatter.string(from: entry.alertDt! as Date)
            
            if !(isAlert.isOn){
                alertDt.textColor = UIColor(named: "White")
                alertDt.isEnabled = false
            }
            
            else{
                alertDt.textColor = UIColor(named: "Black")
                alertDt.isEnabled = true
            }
            
        }
        
        createDatePicker()
        createDatePicker2()
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        msg.text = ""
    }

    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed1))
        toolBar.setItems([done], animated: true)
        
        expDt.inputAccessoryView = toolBar
        
        expDt.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed1(){
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var s = dateFormatter.string(from: datePicker.date)
        expDt.text = s
        self.view.endEditing(true)
    }
    
    func createDatePicker2(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
        toolBar.setItems([done], animated: true)
        
        alertDt.inputAccessoryView = toolBar
        
        alertDt.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed2(){
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var s = dateFormatter.string(from: datePicker.date)
        alertDt.text = s
        self.view.endEditing(true)
    }
    
    func showAlert(msg : String, title : String){
        let sendAlert = UIAlertController(
            title:title,
            message: msg,
            preferredStyle: .alert)
        sendAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        self.present(sendAlert, animated: true){}
    }
}
