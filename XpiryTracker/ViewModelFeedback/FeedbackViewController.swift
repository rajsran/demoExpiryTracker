//
//  FeedbackViewController.swift
//  XpiryTracker
//
//  Created by Qihang on 2020/10/7.
//  Copyright © 2020 qihang. All rights reserved.
//

import UIKit
import MessageUI


class FeedbackViewController : UIViewController,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var message: UITextView!
    
    @IBAction func report(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMail()
            self.present(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    override func viewDidLoad() {
        createkb()
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Configure Mail and set the message body
    func configuredMail() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        mailComposeVC.setToRecipients(["liqihangapp@126.com"])
        mailComposeVC.setSubject("XpiryTracker - Send us a feedback")
        
        let messageSent = message.text!
        let deviceName = UIDevice.current.name
        let systemVerison = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.model
        let deviceUUId = UIDevice.current.identifierForVendor?.uuidString
        
        mailComposeVC.setMessageBody("\(messageSent) \n deviceName:\(deviceName) \n systemVerison:\(systemVerison) \n deviceModel:\(deviceModel) \n deviceUUId:\(deviceUUId ?? nil)", isHTML: false)
        
        return mailComposeVC
    }
    
    //Alert users if they haven't configured email address
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertController(
            title:"Unable to send an Email",
            message: "Your Device hasn't configure an email. Please set in Setting, and retry",
            preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true){}
    }
    
    //ComposeController to allow users send or quit
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func createkb(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([done], animated: true)
        
        message.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        message.endEditing(true)
    }
    
}
