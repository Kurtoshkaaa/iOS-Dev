//
//  LaunchVC.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit

class LaunchVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
    let defaults = UserDefaults.standard
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DBHelper().createWatchlistTable()
        
        activityIndicator.startAnimating()
        
        if let deviceToken = defaults.value(forKey: "DeviceToken") as? String {
            Global.deviceToken = deviceToken
        } else {
            Global.deviceToken = "simulator"
        }
        
        if let language = defaults.value(forKey: "appLanguage") as? String {
            Global.currentLanguage = language
        } else {
            Global.currentLanguage = "en"
        }
        
        self.perform(#selector(navigateToHome), with: nil, afterDelay: 2.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //MARK: - Navigation Method
    @objc func navigateToHome() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        AppDel.navigateToHome()
    }
}
