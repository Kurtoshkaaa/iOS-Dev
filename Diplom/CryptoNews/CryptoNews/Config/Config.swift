//
//  Config.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit

enum Server: String {
    case Sandbox = "https://sandbox-api.coinmarketcap.com/v1/"
    case Production = "https://pro-api.coinmarketcap.com/v1/"
}

enum APIKey: String {
    case Sandbox = "b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c"
    case Production = "79e1980d-ac4d-4932-8d37-d58b461b5230"
}

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let AppDel = UIApplication.shared.delegate as! AppDelegate
let Global = GlobalClass.sharedinstance
let charSet = CharacterSet.whitespacesAndNewlines

let kAppName = "Crypto News"
let kDeviceType = "IOS"

let kCurrencyIconPath = "https://cryptoicons.org/api/"
let kCurrencyIconColor = "black"
let kCurrencyIconSize = "300"

let kAppBlueColor = UIColor(named: "AppBlue")!
let kAppGrayColor = UIColor(named: "AppGray")!
let kAppGrayLightColor = UIColor(named: "AppGrayLight")!
let kAppOrangeColor = UIColor(named: "AppOrange")!
let kAppTextColor = UIColor(named: "AppText")!

let kNavigationTitleFontSize: CGFloat = 18.0
let kNavigationBarColor = kAppGrayColor
let kNavigationTitleColor = kAppTextColor
let kTextFieldPlaceholderColor = UIColor.lightGray

let serverURL = Server.Production.rawValue
let cryptoAPIKey = APIKey.Production.rawValue
let kPrivacyURL = "\(serverURL)privacy-policy"
let kTermsURL = "\(serverURL)terms-and-condition"
let kAboutURL = "\(serverURL)about-us"

//MARK: API URLs
let kGetCryptoCurrency = "cryptocurrency/listings/latest"
let kGetCryptoCurrencyInfo = "cryptocurrency/info"

//MARK: Connectivity Messages
let kNoInternet = "No Internet Connection. Make sure your device is connected to the internet."
let kServerIssue = "There seems to be some problem either with your connection or our server, please try again."
let kInvalidResponse = "Invalid Server Response"
let kTryAgain = "Unable to connect with server. Please try again later."
let kEmailNotConfiguredMessage = "Unable to send email. Please check your device's email configuration"

//MARK: Validation Messages

//MARK:- Title Messages
let kOk = "OK"
let kYes = "Yes"
let kNo = "No"
let kCancel = "Cancel"
let kConfirm = "Confirm"
let kPullToRefresh = "Pull to refresh"

