//
//  CurrencyTableViewCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 22/11/2022.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    static let identifier = "CurrencyTableViewCell"

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var shortSymbolLB: UILabel!
    @IBOutlet weak var symbolLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var countryLB: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        flagImageView.clipsToBounds = true
        flagImageView.layer.cornerRadius = 8
//        backView.layer.cornerRadius = 12
//        backView.layer.shadowColor = UIColor.systemGray.cgColor
//        backView.layer.shadowOpacity = 1
//        backView.layer.shadowOffset = .zero //CGSize(width: 0, height: 0.5)
//        backView.layer.shadowRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CurrencyTableViewCell", bundle: nil)
    }
    
    func setData(country: String, name: String, symbol: String, shortSymbol: String, flagName: String) {
        flagImageView.image = UIImage(named: flagName)
        countryLB.text = country
        nameLB.text = name
        symbolLB.text = symbol
        shortSymbolLB.text = shortSymbol
        
    }
    
    func checkSelected(selected: Bool) {
        if selected {
            checkButton.isHidden = false
        } else {
            checkButton.isHidden = true
        }
    }
    
}
