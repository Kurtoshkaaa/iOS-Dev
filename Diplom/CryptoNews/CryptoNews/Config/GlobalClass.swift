//
//  GlobalClass.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit

class GlobalClass {
    //MARK: - Variables
    static let sharedinstance = GlobalClass()
    var deviceToken = "simulator"
    var currentLanguage = "en"

    //MARK: - Methods
    func showNetworkAlert() {
        DispatchQueue.main.async {
            AppDel.window?.endEditing(true)
            
            let networkAlert = UIAlertController(title: kAppName, message: kNoInternet, preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: kOk, style: .default, handler: nil))
            AppDel.window?.rootViewController?.present(networkAlert, animated: true, completion: nil)
        }
    }
    
    func showAlert(_ message: String) {
        DispatchQueue.main.async {
            AppDel.window?.endEditing(true)
            
            let normalAlert = UIAlertController(title: kAppName, message: message, preferredStyle: .alert)
            normalAlert.addAction(UIAlertAction(title: kOk, style: .default, handler: nil))
            AppDel.window?.rootViewController?.present(normalAlert, animated: true, completion: nil)
        }
    }
    
    func convertStringToDate(strDate: String, curFor: String, newFor: String, isUTC: Bool) -> (Date, String) {
        let dateFormatter = DateFormatter()
        if isUTC {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        dateFormatter.dateFormat = curFor
        let date = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = newFor
        dateFormatter.timeZone = TimeZone.current
        var strDate = ""
        if date == nil {
            return (Date(), strDate)
        } else {
            strDate = dateFormatter.string(from: date!)
            return (date!, strDate)
        }
    }
}

