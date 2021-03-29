
import Foundation
import UIKit

struct AddProductViewModel {
    
    private var productManager = ProductManager.shared
    private var restModel = RestApi.sharedInstance
    private var notificationModel = AddNotification.sharedInstance
    
    mutating func addProduct(_ pName : String, _ pImage : UIImage, _ expiryDt : Date, _ alertDt : Date,_ isAlert : Bool,_ quantity : Int32) -> String{
        
        var response = productManager.addProduct(pName, pImage, expiryDt, alertDt, isAlert, quantity)
        
        return response
    }
    
    mutating func getProductName_Api(with barcode:String) -> String
    {
        return restModel.getProductName(with: barcode)
    }
    
    func setNotification(alertDate: String, productName: String, qty: String){
        notificationModel.setNotification(alertDate: alertDate, productName: productName, qty: qty)
    }
}
