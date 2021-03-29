
import UIKit
import BarcodeScanner
class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let datePicker = UIDatePicker()
    
    private var viewModel = AddProductViewModel()
    
    @IBOutlet weak var pName: UITextField!
    
    
    @IBAction func onScan(_ sender: Any) {

        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        present(viewController, animated: true, completion: nil)
    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
    
    
    @IBOutlet weak var quantity: UITextField!
    
    
    @IBOutlet weak var st: UIStepper!
    
    @IBAction func stepper(_ sender: UIStepper) {
        sender.minimumValue = 1
        quantity.text = Int(sender.value).description
    }
    
    @IBOutlet weak var expiryDt: UITextField!
    
    @IBOutlet weak var isAlert: UISwitch!
    
    @IBOutlet weak var alertDtLabel: UILabel!
    
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
    
    @IBAction func onFillExpDt(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dt1 = expiryDt.text
        if (dt1 == ""){
            return
        }
            
        else if(alertDt.text != ""){
            return
        }
            
        else{
            if let s = dateFormatter.date(from: dt1!){
                let alertDate = Calendar.current.date(byAdding: .day, value: -1, to: s)
                
                let date = NSDate()
                var dateString = dateFormatter.string(from: alertDate!)
                alertDt.text = dateString
            }
            
        }
    }
    
    @IBOutlet weak var pImage: UIImageView!
    
    
    
    @IBAction func add(_ sender: Any) {
        
        guard let name = pName.text, let qty = Int32(quantity.text!) else {
            return
        }
        
        if (name==""){
            showAlert(msg: "Enter name of the product", title: "Error")
            msg.text = "Enter name of product"
            return
        }
        
        if (qty <= 0){
            showAlert(msg: "Enter product quantity that is greater than 0", title:"Error")
            return
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var date1 : Date
        var date2 : Date
        
        guard let d1 = expiryDt.text else {
            msg.text = "Enter expiry date"
            return
        }
        
        if (d1==""){
            showAlert(msg: "Choose an expiry date in the future.", title: "Error")
            msg.text = "Enter expiry date"
            return
        }
        
        date1 = dateFormatter.date(from:d1)!
        
        guard var d2 = alertDt.text else {
            return
        }
        
        date2 = dateFormatter.date(from:d2)!
        let today = Date()
        
        if (date2<today && isAlert.isOn){
            showAlert(msg: "Alert date has passed by.", title: "Error")
            return
        }
            
        else if (date2>date1 && isAlert.isOn){
            showAlert(msg: "Select an alert date prior to expiry date.", title: "Error")
            msg.text = "Selected alert date is after expiry date"
            return
        }
        
        guard let img = pImage.image else {
            showAlert(msg: "Photo unavailable.", title: "Error")
            return
        }
        
        if isAlert.isOn
        {
            self.setNotification(alertDate: alertDt.text!, productName: pName.text!, qty: quantity.text!)
        }
        
        let on = isAlert.isOn
        
        var response = viewModel.addProduct(name, img, date1, date2, on, qty)
        showAlert(msg: response, title: "Success")
        msg.text = "Entry has been added."
        
        pName.text = ""
        quantity.text = "1"
        st.value = 1
        expiryDt.text = ""
        isAlert.isOn = true
        alertDt.text = ""
        alertDt.textColor = UIColor.black
        pImage.image = UIImage(named: "add-photo-icon-19")
    }
    
    func setNotification(alertDate: String, productName: String, qty: String){
        viewModel.setNotification(alertDate: alertDate, productName: productName, qty: qty)
    }
    
    @IBOutlet weak var msg: UILabel!
    
    override func viewDidLoad() {
        createkb()
        super.viewDidLoad()
        quantity.text = "1"
        st.value = 1
        quantity.isEnabled = false
        msg.text = ""
        
        createDatePicker()
        createDatePicker2()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pImage.isUserInteractionEnabled = true
        pImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        msg.text = ""
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { ( action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("Camera not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { ( action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed1))
        toolBar.setItems([done], animated: true)
        
        expiryDt.inputAccessoryView = toolBar
        
        expiryDt.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        pImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func donePressed1(){
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var s = dateFormatter.string(from: datePicker.date)
        expiryDt.text = s
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
    
}


extension AddProductViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        let productName = viewModel.getProductName_Api(with: code)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if productName == "No result"{
                controller.resetWithError()
            }
            else{
                self.pName.text = productName
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - BarcodeScannerErrorDelegate

extension AddProductViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate

extension AddProductViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(msg : String, title : String){
        let sendAlert = UIAlertController(
            title:title,
            message: msg,
            preferredStyle: .alert)
        sendAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        self.present(sendAlert, animated: true){}
    }
    
    func createkb(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([done], animated: true)
        
        pName.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        pName.endEditing(true)
    }
}

