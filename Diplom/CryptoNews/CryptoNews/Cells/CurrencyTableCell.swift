//
//  CurrencyTableCell.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit
import SDWebImage

class CurrencyTableCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var imgCurrency: UIImageView!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblCurrencySymbol: UILabel!
    @IBOutlet weak var lblMarketCap: UILabel!
    @IBOutlet weak var lblUSDPrice: UILabel!
    @IBOutlet weak var lblCryptoPrice: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCurrencyCell(currency: Currency, logo: String) {
//        let currencyIconPath = String(format: "%@%@/%@/%@", kCurrencyIconPath, kCurrencyIconColor, (currency.symbol ?? "").lowercased(), kCurrencyIconSize)
        let currencyIconURL = URL(string: logo)
        imgCurrency.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgCurrency.sd_setImage(with: currencyIconURL, placeholderImage: UIImage(named: "CircleIcon"), options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            self.imgCurrency.sd_imageIndicator?.stopAnimatingIndicator()
        })
        
        lblCurrency.text = currency.name
        lblCurrencySymbol.text = currency.symbol
        lblMarketCap.text = String(format: "Market Cap: $%@", formatNumber(Int(currency.quote?.usd?.marketCap ?? 0)))
        
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
        
        lblVolume.text = String(format: "Volume (24h): $ %@", formatNumber(Int(currency.quote?.usd?.volume24H ?? 0)))
    }
}

