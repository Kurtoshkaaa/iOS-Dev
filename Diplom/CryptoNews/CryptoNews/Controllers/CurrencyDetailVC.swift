//
//  CurrencyDetailVC.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit
import SDWebImage
import SVProgressHUD
import SwiftCharts

enum ChartType {
    case Price
    case MarketCap
    case Volume
}

class CurrencyDetailVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var imgCurrency: UIImageView!
    @IBOutlet weak var lblCurrencyTitle: UILabel!
    @IBOutlet weak var lblCurrencySymbol: UILabel!
    @IBOutlet weak var lblUSDPrice: UILabel!
    @IBOutlet weak var lblCryptoPrice: UILabel!
    @IBOutlet weak var colTime: UICollectionView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var chartLoader: UIActivityIndicatorView!
    @IBOutlet weak var segmentInfo: UISegmentedControl!
    @IBOutlet weak var tblInfo: UITableView!
    @IBOutlet weak var tblInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblStaticAbout: UILabel!
    @IBOutlet weak var lblAboutInfo: UILabel!
    
    //MARK: - Variables
    var watchlistButton: UIBarButtonItem!
    var currency: Currency?
    var currencyInfo = [String : Any]()
    var selectedTimeIndex: Int = 5
    
    var arrTime = ["All", "1y", "6m", "1m", "7d", "24h", "1h"]
    var arrInfo = ["Volume (24h)", "Marker Cap", "Circ. supply", "Total Supply", "Max Supply", "Change (1h)", "Change (24h)", "Change (7d)"]
    var arrValues = ["No Data", "No Data", "No Data", "No Data", "No Data", "No Data", "No Data", "No Data"]
    
    fileprivate var chart: Chart?
    
    var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    var iPhoneChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPhoneChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    var chartType: ChartType = .Price
    var startDate: Date?
    var endDate: Date?
    var prices = [[Double]]()
    var marketCap = [[Double]]()
    var volume = [[Double]]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        endDate = Date()
        
        loadCurrencyInfo()
        loadCurrencyValues()
        fetchChartData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = currency?.name ?? "Crypto"
        self.setupNavigationBar(isTranslucent: false, backgroundColor: kNavigationBarColor, titleColor: kNavigationTitleColor)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.addLeftButtonWithImage(self, action: #selector(actionButtonBack), buttonImage: #imageLiteral(resourceName: "icArrowBackWhite"))
        
        if let currencyID = currency?.id {
            if DBHelper().isCurrencyWatchlisted(currencyID: currencyID) {
                watchlistButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icWatchlistOn"), style: .plain, target: self, action: #selector(actionRemoveFromWatchlist))
            } else {
                watchlistButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icWatchlistOff"), style: .plain, target: self, action: #selector(actionAddToWatchlist))
            }
            
            self.navigationItem.rightBarButtonItem = watchlistButton
        }
        
        tblInfo.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tblInfo.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                let newsize = newvalue as! CGSize
                tblInfoHeightConstraint.constant = newsize.height
            }
        }
    }
    
    //MARK: - Helper
    func loadCurrencyInfo() {
        if let currency = currency {
            let currencyIconPath = currencyInfo["logo"] as? String ?? ""
            let currencyIconURL = URL(string: currencyIconPath)
            imgCurrency.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgCurrency.sd_setImage(with: currencyIconURL, placeholderImage: UIImage(named: "CircleIcon"), options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                self.imgCurrency.sd_imageIndicator?.stopAnimatingIndicator()
            })
            
            lblCurrencyTitle.text = currency.name
            lblCurrencySymbol.text = currency.symbol
            
            let usdPrice = String(format: "$ %.2f", currency.quote?.usd?.price ?? 0)
            let changePer = currency.quote?.usd?.percentChange24H ?? 0
            let attributedPrice = NSMutableAttributedString(string: usdPrice)
            var attributedChange = NSAttributedString()
            if changePer == 0 {
                attributedChange = NSMutableAttributedString(string: String(format: " (%.2f%%)", changePer), attributes: [NSAttributedString.Key.foregroundColor: kAppGrayLightColor])
            } else if changePer < 0 {
                attributedChange = NSMutableAttributedString(string: String(format: " (%.2f%%)", changePer), attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            } else {
                attributedChange = NSMutableAttributedString(string: String(format: " (%.2f%%)", changePer), attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 80.0/255.0, green: 200.0/255.0, blue: 120.0/255.0, alpha: 1.0)])
            }
            
            attributedPrice.append(attributedChange)
            lblUSDPrice.attributedText = attributedPrice
            
            if let usdPrice = currency.quote?.usd?.price, usdPrice > 0 {
                lblCryptoPrice.text = String(format: "%.8f %@", 1.0/usdPrice, "BTC")
            } else {
                lblCryptoPrice.text = ""
            }
            
            lblStaticAbout.text = String(format: "About %@", currency.name ?? "")
            lblAboutInfo.text = currencyInfo["description"] as? String ?? ""
        }
    }
    
    func loadCurrencyValues() {
        if let volume24h = currency?.quote?.usd?.volume24H {
            arrValues[0] = volume24h.toCurrency()
        }
        
        if let marketCap = currency?.quote?.usd?.marketCap {
            arrValues[1] = marketCap.toCurrency()
        }
        
        if let circSupply = currency?.circulatingSupply {
            arrValues[2] = circSupply.toCurrency()
        }
        
        if let totalSupply = currency?.totalSupply {
            arrValues[3] = totalSupply.toCurrency()
        }
        
        if let maxSupply = currency?.maxSupply {
            arrValues[4] = maxSupply.toCurrency()
        }
        
        if let change1h = currency?.quote?.usd?.percentChange1H {
            arrValues[5] = String(format: "%.2f%%", change1h)
        }
        
        if let change24h = currency?.quote?.usd?.percentChange24H {
            arrValues[6] = String(format: "%.2f%%", change24h)
        }
        
        if let change7d = currency?.quote?.usd?.percentChange7D {
            arrValues[7] = String(format: "%.2f%%", change7d)
        }
        
        tblInfo.reloadData()
    }
    
    func setupChartView() {
        chartView.subviews.forEach { $0.removeFromSuperview() }
        
        let labelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 10.0))
        var dataPoints = [[Double]]()
        
        if chartType == .Price {
            dataPoints = prices
        } else if chartType == .MarketCap {
            dataPoints = marketCap
        } else if chartType == .Volume {
            dataPoints = volume
        }
        
        let chartPoints = dataPoints.compactMap{(ChartPoint(x: ChartAxisValueString("", order: Int($0[0]), labelSettings: labelSettings), y: ChartAxisValueString(formatNumber(Int($0[1])), order: Int($0[1]))))}
        if chartPoints.count > 0 {
            let xValues = chartPoints.map{$0.x}
            let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueString(formatNumber(Int($0)), order: Int($0))}, addPaddingSegmentIfEdge: false)
            
            let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
            let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings.defaultVertical()))

            let chartFrame = CGRect(x: 0, y: 0, width: chartView.frame.size.width, height: chartView.frame.size.height)
            
            let chartSettings = iPhoneChartSettingsWithPanZoom

            let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
            let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
            
            let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: kAppOrangeColor, animDuration: 1, animDelay: 0)
            let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], useView: false)
            
            let thumbSettings = ChartPointsLineTrackerLayerThumbSettings(thumbSize: 10, thumbBorderWidth: 2)
            let trackerLayerSettings = ChartPointsLineTrackerLayerSettings(thumbSettings: thumbSettings)
            
            var currentPositionLabels: [UILabel] = []
            
            let chartPointsTrackerLayer = ChartPointsLineTrackerLayer<ChartPoint, Any>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lines: [chartPoints], lineColor: kAppGrayLightColor, animDuration: 1, animDelay: 2, settings: trackerLayerSettings) {chartPointsWithScreenLoc in

                currentPositionLabels.forEach{$0.removeFromSuperview()}
                
                for (index, chartPointWithScreenLoc) in chartPointsWithScreenLoc.enumerated() {
                    let label = UILabel()
                    label.text = chartPointWithScreenLoc.chartPoint.description
                    label.font = UIFont.systemFont(ofSize: 10)
                    label.sizeToFit()
                    label.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x + label.frame.width / 2, y: chartPointWithScreenLoc.screenLoc.y + chartFrame.minY - label.frame.height / 2)
                    
                    label.backgroundColor = kAppGrayColor
                    label.textColor = UIColor.white
                    
                    currentPositionLabels.append(label)
                    self.chartView.addSubview(label)
                }
            }
            
            //let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: 0.1)
            //let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
            
            let chart = Chart(
                frame: chartFrame,
                innerFrame: innerFrame,
                settings: chartSettings,
                layers: [
                    xAxisLayer,
                    yAxisLayer,
                    //guidelinesLayer,
                    chartPointsLineLayer,
                    chartPointsTrackerLayer
                ]
            )
            
            self.chartView.addSubview(chart.view)
            self.chart = chart
        }
    }
    
    //MARK: - Button Action Methods
    @objc func actionButtonBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionAddToWatchlist() {
        if let currencyID = currency?.id {
            var dicInfo = [String : Any]()
            dicInfo["currency"] = try? currency?.jsonString()
            dicInfo["detail"] = currencyInfo
            
            if let json = try? dicInfo.toJson() {
                DBHelper().insertDataInWatchlistTable(currencyID: currencyID, currencyInfo: json)
                watchlistButton.image = #imageLiteral(resourceName: "icWatchlistOn")
            }
        }
    }
    
    @objc func actionRemoveFromWatchlist() {
        if let currencyID = currency?.id {
            DBHelper().deleteDataFromWatchlistTableWithCurrencyID(currencyID: currencyID)
            watchlistButton.image = #imageLiteral(resourceName: "icWatchlistOff")
        }
    }
    
    @IBAction func actionSegmentInfoChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            chartType = .Price
        } else if sender.selectedSegmentIndex == 1 {
            chartType = .MarketCap
        } else if sender.selectedSegmentIndex == 2 {
            chartType = .Volume
        }
        
        setupChartView()
    }
    
    //MARK: - API Methods
    func fetchChartData() {
        if let currencyName = currency?.name, let startDate = self.startDate, let endDate = self.endDate {
            chartLoader.isHidden = false
            chartLoader.startAnimating()
            
            let startTimeStamp = startDate.timeIntervalSince1970
            let endTimeStamp = endDate.timeIntervalSince1970
            
            let apiPath = String(format: "https://api.coingecko.com/api/v3/coins/%@/market_chart/range?vs_currency=usd&from=%f&to=%f", String(currencyName.filter { !" ".contains($0) }).lowercased(), startTimeStamp, endTimeStamp)
            APIManager.shared().callAPIWithParameters(apiPath: apiPath, requestType: .GET, parameters: nil) { data, reponse, error in
                DispatchQueue.main.async {
                    self.chartLoader.isHidden = true
                    self.chartLoader.stopAnimating()
                    
                    if error == nil {
                        if let responseData = data {
                            do {
                                let responseDic = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? NSDictionary
                                if let reponse = responseDic?.dictionaryByReplacingNullsWithBlanks(), let chartInfo = reponse as? [String : Any] {
                                    if let price = chartInfo["prices"] as? [[Any]] {
                                        self.prices = price.compactMap({ values in
                                            return values as? [Double]
                                        })
                                    }
                                    
                                    if let mc = chartInfo["market_caps"] as? [[Any]] {
                                        self.marketCap = mc.compactMap({ values in
                                            return values as? [Double]
                                        })
                                    }
                                    
                                    if let tv = chartInfo["total_volumes"] as? [[Any]] {
                                        self.volume = tv.compactMap({ values in
                                            return values as? [Double]
                                        })
                                    }
                                    
                                    self.setupChartView()
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
}

extension CurrencyDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/7 - 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionCell", for: indexPath) as! TimeCollectionCell
        cell.lblTitle.text = arrTime[indexPath.row]
        if selectedTimeIndex == indexPath.item {
            cell.viewBack.backgroundColor = kAppOrangeColor
        } else {
            cell.viewBack.backgroundColor = kAppGrayLightColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTimeIndex = indexPath.item
        switch indexPath.item {
        case 0:
            startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        case 1:
            startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        case 2:
            startDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
        case 3:
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        case 4:
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        case 5:
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        case 6:
            startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        default:
            break
        }
        
        fetchChartData()
        collectionView.reloadData()
    }
}

extension CurrencyDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrInfo.count == 0 {
            tableView.showNoDataMessage("No data available")
        } else {
            tableView.restore()
        }
        
        return arrInfo.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyInfoTableCell", for: indexPath) as! CurrencyInfoTableCell
        cell.lblTitle.text = arrInfo[indexPath.row]
        cell.lblValue.text = arrValues[indexPath.row]
        
        if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 {
            if let value = Double(cell.lblValue.text?.dropLast() ?? "") {
                if value == 0 {
                    cell.lblValue.textColor = kAppGrayLightColor
                } else if value < 0 {
                    cell.lblValue.textColor = UIColor.red
                } else {
                    cell.lblValue.textColor = UIColor(red: 80.0/255.0, green: 200.0/255.0, blue: 120.0/255.0, alpha: 1.0)
                }
            }
        }
        
        return cell
    }
}

extension Double {
    func toCurrency() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        return currencyFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Dictionary {
    func toJson() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError(domain: "Dictionary", code: 1, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
}

extension String {
    func toObject() throws -> [String : Any]? {
        let data = self.data(using: .utf8)!
        do {
            if let object = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String : Any] {
               return object
            } else {
                return nil
            }
        } catch _ as NSError {
            return nil
        }
    }
}

