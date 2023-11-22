//
//  MarketCapVC.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit
import SVProgressHUD

class MarketCapVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tblCurrency: UITableView!
    
    //MARK: - Variables
    var arrCurrency = [Currency]()
    var currencyInfo = [String : Any]()
    var refreshControl = UIRefreshControl()
    
    var totalCount: Int = 0
    var currentPage: Int = 1
    var perPageCount: Int = 50
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: kPullToRefresh)
        tblCurrency.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "Market Cap"
        self.setupNavigationBar(isTranslucent: false, backgroundColor: kNavigationBarColor, titleColor: kNavigationTitleColor)
        
        if arrCurrency.count == 0 {
            fetchCryptoData(loader: true)
        } else {
            tblCurrency.reloadData()
        }
    }
    
    //MARK: - Helper Methods
    @objc func refresh(sender: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            currentPage = 1
            refreshControl.endRefreshing()
            fetchCryptoData(loader: false)
        }
    }
    
    //MARK: - API Methods
    func fetchCryptoData(loader: Bool) {
        if loader {
            SVProgressHUD().defaultMaskType = .gradient
            SVProgressHUD.show()
        }
        
        let apiPath = String(format: "%@%@?CMC_PRO_API_KEY=%@&start=%d&limit=%d", serverURL, kGetCryptoCurrency, cryptoAPIKey, currentPage, perPageCount)
        APIManager.shared().callAPIWithParameters(apiPath: apiPath, requestType: .GET, parameters: nil) { data, response, error in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if error == nil {
                    if let responseData = data {
                        do {
                            let crypto = try Crypto(data: responseData)
                            if let errorCode = crypto.status?.errorCode, errorCode != 0 {
                                self.showAlert(crypto.status?.errorMessage ?? kServerIssue, nil)
                            } else {
                                self.totalCount = crypto.status?.totalCount ?? 0
                                if self.currentPage == 1 {
                                    self.arrCurrency.removeAll()
                                }
                                
                                if let data = crypto.data {
                                    let ids = (data.compactMap({ $0.id })).compactMap({ String($0) }).joined(separator: ",")
                                    if ids.count > 0 {
                                        self.fetchCurrencyDetails(currencyIDs: ids, loader: false)
                                    }
                                    
                                    self.arrCurrency.append(contentsOf: data)
                                }
                            }
                            
                            self.tblCurrency.reloadData()
                        } catch let error as NSError {
                            self.showAlert(error.localizedDescription, nil)
                        }
                    }
                } else {
                    self.showAlert(error?.localizedDescription ?? kServerIssue, nil)
                }
            }
        }
    }
    
    //MARK: - API Methods
    func fetchCurrencyDetails(currencyIDs: String, loader: Bool) {
        if loader {
            SVProgressHUD().defaultMaskType = .gradient
            SVProgressHUD.show()
        }
        
        let apiPath = String(format: "%@%@?CMC_PRO_API_KEY=%@&id=%@", serverURL, kGetCryptoCurrencyInfo, cryptoAPIKey, currencyIDs)
        APIManager.shared().callAPIWithParameters(apiPath: apiPath, requestType: .GET, parameters: nil) { data, response, error in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if error == nil {
                    if let responseData = data {
                        do {
                            let responseDic = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? NSDictionary
                            if let dataDict = (responseDic?.object(forKey: "data") as? NSDictionary)?.dictionaryByReplacingNullsWithBlanks(), let info = dataDict as? [String : Any] {
                                self.currencyInfo.merge(info) { (current, _) in current }
                                self.tblCurrency.reloadData()
                            }
                        } catch let error as NSError {
                            self.showAlert(error.localizedDescription, nil)
                        }
                    }
                } else {
                    self.showAlert(error?.localizedDescription ?? kServerIssue, nil)
                }
            }
        }
    }
}

extension MarketCapVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrCurrency.count == 0 {
            tableView.showNoDataMessage("No data available")
        } else {
            tableView.restore()
        }
        
        return arrCurrency.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableCell", for: indexPath) as! CurrencyTableCell
        
        var currencyLogo: String = ""
        if let currencyID = arrCurrency[indexPath.row].id {
            if let info = currencyInfo[String(currencyID)] as? [String : Any] {
                currencyLogo = info["logo"] as? String ?? ""
            }
        }
        
        cell.configureCurrencyCell(currency: arrCurrency[indexPath.row], logo: currencyLogo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if arrCurrency.count >= perPageCount && indexPath.row == arrCurrency.count - 1 {
            if totalCount > currentPage * perPageCount {
                currentPage = arrCurrency.count + 1
                fetchCryptoData(loader: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "CurrencyDetailVC") as! CurrencyDetailVC
        objVC.currency = arrCurrency[indexPath.row]
        if let currencyID = arrCurrency[indexPath.row].id {
            if let info = currencyInfo[String(currencyID)] as? [String : Any] {
                objVC.currencyInfo = info
            }
        }
        
        self.navigationController?.pushViewController(objVC, animated: true)
    }
}

