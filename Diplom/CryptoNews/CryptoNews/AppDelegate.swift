//
//  AppDelegate.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarDelegate, UITabBarControllerDelegate {
    
    //MARK: - Variables
    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var navigationController = UINavigationController()
    let appTabBar = UITabBarController()
    
    //MARK: - Application Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0
        (UILabel.appearance(whenContainedInInstancesOf: [UITextField.self])).textColor = kTextFieldPlaceholderColor
        
        let accessoryView = KeyboardAccessoryToolbar()
        UITextField.appearance().inputAccessoryView = accessoryView
        UITextView.appearance().inputAccessoryView = accessoryView
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        } else {
            appTabBar.tabBar.backgroundColor = .white
            UITabBar.appearance().backgroundColor = .white
        }
        
        navigationController.setupNavigationBar(isTranslucent: false, backgroundColor: kNavigationBarColor, titleColor: kNavigationTitleColor)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        let objVC = self.storyboard.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
        self.navigationController = UINavigationController(rootViewController: objVC)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    //MARK: - TabBar Methods
    func createTabBar() {
        let newsVC = self.storyboard.instantiateViewController(withIdentifier: "NewsVC") as! NewsVC
        let marketCapVC = self.storyboard.instantiateViewController(withIdentifier: "MarketCapVC") as! MarketCapVC
        let watchlistVC = self.storyboard.instantiateViewController(withIdentifier: "WatchlistVC") as! WatchListVC
        
        let newsNVC = UINavigationController(rootViewController: newsVC)
        newsNVC.isNavigationBarHidden = false
        
        let marketCapNVC = UINavigationController(rootViewController: marketCapVC)
        marketCapNVC.isNavigationBarHidden = false
        
        let watchlistNVC = UINavigationController(rootViewController: watchlistVC)
        watchlistNVC.isNavigationBarHidden = false
        
        let allControllers = [newsNVC, marketCapNVC, watchlistNVC]
        appTabBar.viewControllers = allControllers
        appTabBar.delegate = self
        appTabBar.tabBar.tintColor = kAppGrayColor
        appTabBar.tabBar.unselectedItemTintColor = kAppGrayLightColor
        
        let tabItemNews: UITabBarItem = appTabBar.tabBar.items![0]
        tabItemNews.title = "News"
        tabItemNews.image = UIImage (named: "icTabNews")?.withRenderingMode(.alwaysOriginal)
        tabItemNews.selectedImage = UIImage (named: "icTabNewsSel")?.withRenderingMode(.alwaysOriginal)
        tabItemNews.imageInsets = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        
        let tabItemMarketCap: UITabBarItem = appTabBar.tabBar.items![1]
        tabItemMarketCap.title = "Market Cap"
        tabItemMarketCap.image = UIImage (named: "icTabMarketCap")?.withRenderingMode(.alwaysOriginal)
        tabItemMarketCap.selectedImage = UIImage (named: "icTabMarketCapSel")?.withRenderingMode(.alwaysOriginal)
        tabItemMarketCap.imageInsets = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        
        let tabItemWatchlist: UITabBarItem = appTabBar.tabBar.items![2]
        tabItemWatchlist.title = "Watchlist"
        tabItemWatchlist.image = UIImage (named: "icTabWatchlist")?.withRenderingMode(.alwaysOriginal)
        tabItemWatchlist.selectedImage = UIImage (named: "icTabWatchlistSel")?.withRenderingMode(.alwaysOriginal)
        tabItemWatchlist.imageInsets = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kAppGrayLightColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kAppGrayColor], for: .selected)
        UITabBar.appearance().barTintColor = kAppGrayColor
        
        self.window!.rootViewController = appTabBar
        self.window?.makeKeyAndVisible()
    }
    
    //MARK: - Helper Methods
    func navigateToHome() {
        createTabBar()
        appTabBar.selectedIndex = 0
    }
}


