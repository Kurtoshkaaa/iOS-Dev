//
//  NewsTableCell.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit
import FeedKit
import SDWebImage

class NewsTableCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureNewsCell(news: RSSFeedItem) {
        if let thumbnail = news.media?.mediaContents?[0], let imagePath = thumbnail.attributes?.url {
            let imageURL = URL(string: imagePath)
            imgNews.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgNews.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "CircleIcon"), options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                self.imgNews.sd_imageIndicator?.stopAnimatingIndicator()
            })
        }
        
        lblTitle.text = news.title
        if let dc = news.dublinCore, let creator = dc.dcCreator {
            lblTime.text = creator
        } else {
            lblTime.text = ""
        }
    }
}

