//
//  NewsVC.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit
import FeedKit
import SVProgressHUD

class NewsVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tblNews: UITableView!
    
    //MARK: - Variables
    var rssFeed: RSSFeed?
    var refreshControl = UIRefreshControl()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: kPullToRefresh)
        tblNews.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "News"
        self.setupNavigationBar(isTranslucent: false, backgroundColor: kNavigationBarColor, titleColor: kNavigationTitleColor)
        
        if rssFeed == nil {
            fetchCryptoNews(loader: true)
        } else {
            tblNews.reloadData()
        }
    }
    
    //MARK: - Helper Methods
    @objc func refresh(sender: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            refreshControl.endRefreshing()
            fetchCryptoNews(loader: false)
        }
    }
    
    //MARK: - API Methods
    func fetchCryptoNews(loader: Bool) {
        if loader {
            SVProgressHUD().defaultMaskType = .gradient
            SVProgressHUD.show()
        }
        
        let feedURL = URL(string: "https://cointelegraph.com/rss")!
        let parser = FeedParser(URL: feedURL)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                switch result {
                case .success(let feed):
                    self.rssFeed = feed.rssFeed
                case .failure(let error):
                    print(error)
                }
                
                self.tblNews.reloadData()
            }
        }
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let feedCount = rssFeed?.items?.count ?? 0
        if feedCount == 0 {
            tableView.showNoDataMessage("No data available")
        } else {
            tableView.restore()
        }
        
        return feedCount
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as! NewsTableCell
        if let news = rssFeed?.items?[indexPath.row] {
            cell.configureNewsCell(news: news)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let news = rssFeed?.items?[indexPath.row], let link = news.link {
            self.openWebURL(link)
        }
    }
}

