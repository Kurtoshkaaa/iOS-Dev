//
//  WatchListVC.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit

class WatchListVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tblWatchlist: UITableView!
    
    //MARK: - Variables
    var arrCurrency = [[String : Any]]()
    var currencyInfo = [String : Any]()
    var refreshControl = UIRefreshControl()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: kPullToRefresh)
        tblWatchlist.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "Watchlist"
        self.setupNavigationBar(isTranslucent: false, backgroundColor: kNavigationBarColor, titleColor: kNavigationTitleColor)
        
        fetchWatchlistData()
    }
    
    //MARK: - Helper Methods
    @objc func refresh(sender: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            refreshControl.endRefreshing()
            fetchWatchlistData()
        }
    }
    
    //MARK: - Data Methods
    func fetchWatchlistData() {
        arrCurrency = DBHelper().readFromWatchlistTable()
        tblWatchlist.reloadData()
    }
}

extension WatchListVC: UITableViewDelegate, UITableViewDataSource {
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
        let data = arrCurrency[indexPath.row]
        if let jsonString = data["currencyInfo"] as? String {
            let dicCurrency = try? jsonString.toObject()
            if let tmpCurrency = dicCurrency?["currency"] as? String {
                let currency = try? Currency(tmpCurrency)
                if let currency = currency {
                    var currencyLogo: String = ""
                    if let info = dicCurrency?["detail"] as? [String : Any] {
                        currencyLogo = info["logo"] as? String ?? ""
                    }
                    
                    cell.configureCurrencyCell(currency: currency, logo: currencyLogo)
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "CurrencyDetailVC") as! CurrencyDetailVC
        let data = arrCurrency[indexPath.row]
        if let jsonString = data["currencyInfo"] as? String {
            let dicCurrency = try? jsonString.toObject()
            if let tmpCurrency = dicCurrency?["currency"] as? String {
                let currency = try? Currency(tmpCurrency)
                if let info = dicCurrency?["detail"] as? [String : Any] {
                    objVC.currencyInfo = info
                }
                
                objVC.currency = currency
            }
        }

        self.navigationController?.pushViewController(objVC, animated: true)
    }
}
