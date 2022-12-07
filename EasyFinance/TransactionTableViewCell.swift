//
//  TransactionTableViewCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 28/11/2022.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var walletLB: UILabel!
    @IBOutlet weak var amountLB: UILabel!    
    @IBOutlet weak var noteLB: UILabel!
    
    static var identifier = "TransactionTableViewCell"
    let formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        noteLB.sizeToFit()
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.bounds.height/2
        formatter.dateFormat = "dd-MM"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TransactionTableViewCell", bundle: nil)
    }
    
    func setData(imageName: String, colorName: String, title: String, note: String?, tranDate: Date, walletName: String, walletColor: String, amount: Double, type: String ) {
        
        if let img = UIImage(systemName: imageName) {
            iconImageView.image = img
        } else {
            iconImageView.image = UIImage(named: imageName)
        }
        iconImageView.tintColor = UIColor(named: colorName)
        
        titleLB.text = title
        noteLB.text = note == "" ? "" : "(" + note! + ")"
        walletLB.text = walletName
        walletLB.textColor = UIColor(named: walletColor)
        amountLB.text = (type == "spend" ? "-" : "+") + String(format: "%.0f %@", locale: Locale.current, amount , globeCurrencyShortSymbol)
        
        dateLB.text = formatter.string(from: tranDate)
        
        amountLB.textColor = type == "spend" ? .red : UIColor(named: "Color30")

        
    }
}
