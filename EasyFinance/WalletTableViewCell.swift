//
//  WalletTableViewCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 23/11/2022.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    static let identifier = "WalletTableViewCell"

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var walletNameLB: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var openBalLB: UILabel!
    @IBOutlet weak var totalSpendLB: UILabel!
    @IBOutlet weak var totalIncomeLB: UILabel!
    @IBOutlet weak var currentBalLB: UILabel!
    @IBOutlet weak var sumImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 12
//        backView.layer.cornerRadius = 12
//        backView.layer.shadowColor = UIColor.systemGray.cgColor
//        backView.layer.shadowOpacity = 1
//        backView.layer.shadowOffset = .zero //CGSize(width: 0, height: 0.5)
//        backView.layer.shadowRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "WalletTableViewCell", bundle: nil)
    }
    
    func setValue(walletName: String, iconName: String, colorName: String, openBal: Double, totalDebit: Double, totalCredit: Double, currentBal: Double, showSumIcon: Bool) {
        
        walletNameLB.text = walletName
        if let image = UIImage(systemName: iconName) {
            iconImageView.image = image
        } else {
            iconImageView.image = UIImage(named: iconName)
        }
        iconImageView.tintColor = UIColor(named: colorName)
        
        openBalLB.text = String(format: "%.0f %@", locale: Locale.current, openBal , globeCurrencyShortSymbol)
        totalSpendLB.text = (totalDebit > 0 ? "-" : "") + String(format: "%.0f %@", locale: Locale.current, totalDebit , globeCurrencyShortSymbol)
        totalIncomeLB.text = (totalCredit > 0 ? "+" : "") + String(format: "%.0f %@", locale: Locale.current, totalCredit , globeCurrencyShortSymbol)
        currentBalLB.text = String(format: "%.0f %@", locale: Locale.current, currentBal , globeCurrencyShortSymbol)
        
        if showSumIcon {
            sumImageView.isHidden = false
        } else {
            sumImageView.isHidden = true
        }
    }
}
