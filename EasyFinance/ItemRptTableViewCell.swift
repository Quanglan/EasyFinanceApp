//
//  ItemRptTableViewCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 03/12/2022.
//

import UIKit

class ItemRptTableViewCell: UITableViewCell {

    static var identifier = "ItemRptTableViewCell"
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var budgetImageView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var budgetLB: UILabel!
    @IBOutlet weak var amountLB: UILabel!
    @IBOutlet weak var amountPercentLB: UILabel!
    @IBOutlet weak var budgetPercentLB: UILabel!
    @IBOutlet weak var titlePercentLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.clipsToBounds = true
        budgetImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.bounds.height/2
        budgetImageView.layer.cornerRadius = budgetImageView.bounds.height/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    static func nib()->UINib {
        return UINib(nibName: "ItemRptTableViewCell", bundle: nil)
    }
    
    func setData(titleText: String, iconName: String, colorName: String, budget: Double, amount: Double, totalSpend: Double, totalIncom: Double, type: String, showPercent: Bool ) {
        
        titleLB.text = titleText
        
        if let img = UIImage(named: iconName) {
            iconImageView.image = img
        } else {
            iconImageView.image = UIImage(systemName: iconName)
        }
        iconImageView.tintColor = UIColor(named: colorName)

        
        if type == "spend" {
            budgetLB.textColor = UIColor(named: "Color30")
            budgetImageView.image = UIImage(named: "budgetgreen")
            amountLB.textColor = .red
            amountLB.text = "-" + String(format: "%.0f %@", locale: Locale.current, amount , globeCurrencyShortSymbol)
            //amountPercentLB.textColor = .red
            amountPercentLB.text = amount > 0 ? String(format: "%.1f", 100 * amount/totalSpend) + "%" : ""
            
            budgetPercentLB.textColor = amount > budget ? .red : UIColor(named: "Color30")
            
        } else {
            budgetLB.textColor = .red
            budgetImageView.image = UIImage(named: "budgetred")
            amountLB.textColor = UIColor(named: "Color30")
            amountLB.text = "+" + String(format: "%.0f %@", locale: Locale.current, amount , globeCurrencyShortSymbol)
            //amountPercentLB.textColor = UIColor(named: "Color30")
            amountPercentLB.text = amount > 0 ? String(format: "%.1f", 100 * amount/totalIncom) + "%" : ""
            budgetPercentLB.textColor = amount < budget ? .red : UIColor(named: "Color30")
        }
        
        if budget > 0 {
            budgetImageView.isHidden = false
            budgetPercentLB.isHidden = false
            budgetLB.isHidden = false
            budgetLB.text = String(format: "%.0f %@", locale: Locale.current, budget , globeCurrencyShortSymbol)
            budgetPercentLB.text = amount > 0 ? String(format: "%.1f", 100 * amount/budget) + "%" : ""
            
        } else {
            budgetImageView.isHidden = true
            budgetPercentLB.isHidden = true
            budgetLB.isHidden = true
        }
        
        if showPercent {
            titlePercentLB.isHidden = false
            amountPercentLB.isHidden = false
        } else {
            titlePercentLB.isHidden = true
            amountPercentLB.isHidden = true
        }
        
        backView.reloadInputViews()
        
    }
}
