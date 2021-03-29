//
//  RestApi.swift
//  XpiryTracker
//
//  Created by Qihang on 2020/10/9.
//  Copyright © 2020 nakhat. All rights reserved.
//

import Foundation
import UIKit



class RestApi{
    static let sharedInstance = RestApi()
    
    private let session = URLSession.shared
    
    private let base_url:String = "https://api.promptapi.com/google_search?q="
    //    private let apiKey: String = "MRV8S4xGK3ZZ8k5Zmhk9dRTc3bjGMMI5"
    private let apiKey: String = "9pNK0QM2KBbuLHxBkLmh1Pcm0u95nlDR"
    
    func  getProductName(with barcode:String) -> String
    {
        let url = base_url + barcode
        
        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        var data = ""
        if let url = URL(string: escapedAddress!)
        {
            var request = URLRequest(url: url,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(apiKey, forHTTPHeaderField: "apikey")
            data = getData(request)
        }
        print("------data----------")
        print(data)
        return data
        
    }
    
    func getData(_ request: URLRequest) -> String{
        var semaphore = DispatchSemaphore (value: 0)
        var title = ""
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("No valid response")
                return
            }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 2xx")
                return
            }
            
            print(httpResponse.statusCode)
            // everything OK, process `data` here
            var parsedResult: Any! = nil
            do
            {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            }
            catch
            {
                print()
            }
            let result = parsedResult as! [String:Any]
            print(result)
            let organic = result["organic"] as! [[String:Any]]
            if organic.count > 0
            {
                let o = organic.first
                title = o!["title"] as! String
                semaphore.signal()
            }
            else
            {
                title = "No result"
            }
        }
        task.resume()
        semaphore.wait()
        return title
    }
    

}

