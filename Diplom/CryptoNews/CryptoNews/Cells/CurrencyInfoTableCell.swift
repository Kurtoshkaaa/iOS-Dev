//
//  CurrencyInfoTableCell.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit

class CurrencyInfoTableCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
