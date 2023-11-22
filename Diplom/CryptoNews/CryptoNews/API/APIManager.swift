//
//  APIManager.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
}

class APIManager: NSObject {
    //MARK:- Class Initializer
    private static let sharedInstance: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    private override init() {}
    
    class func shared() -> APIManager {
        return sharedInstance
    }
    
    //MARK:- Server Communication Methods
    func callAPIWithParameters(apiPath: String, requestType: RequestType, parameters: [String : Any]?, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let apiPathURL = apiPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let apiURL = URL(string: apiPathURL) else { return }
        
        var request = URLRequest(url: apiURL, timeoutInterval: Double.infinity)
        request.httpMethod = requestType.rawValue
        
        if let parameters = parameters {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            
            request.httpBody = httpBody
        }
        
        //Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //Hide Loader
            guard let data = data else {
                completionHandler(data, response, error)
                return
            }
            
            completionHandler(data, response, error)
        }

        task.resume()
    }
}

