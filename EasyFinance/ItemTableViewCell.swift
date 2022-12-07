//
//  ItemTableViewCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 16/11/2022.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    static let identifier = "ItemTableViewCell"

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var budgetImageView: UIImageView!
    @IBOutlet weak var mytextLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var budgetPercentLB: UILabel!
    @IBOutlet weak var amountTitleLB: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backView: UIView!
    
    var editButtonHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        //backView.clipsToBounds = true
//        backView.layer.cornerRadius = 12
//        backView.layer.shadowColor = UIColor.systemGray.cgColor
//        backView.layer.shadowOpacity = 1
//        backView.layer.shadowOffset = .zero //CGSize(width: 0, height: 0.5)
//        backView.layer.shadowRadius = 10
        myImageView.clipsToBounds = true
        myImageView.layer.cornerRadius = myImageView.bounds.height/2
        budgetImageView.clipsToBounds = true
        budgetImageView.layer.cornerRadius = budgetImageView.bounds.height/2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ItemTableViewCell", bundle: nil)
    }
    
    func setData(imageName: String, colorName: String, title: String, budget: Double, amount: Double, type: String, editBtn: Bool) {
        
        budgetLabel.text = ""
        amountLabel.text = ""
        budgetLabel.sizeToFit()
        amountLabel.sizeToFit()
        
        mytextLabel.text = title
        
        if let image = UIImage(named: imageName) {
            myImageView.image = image
        } else {
            myImageView.image = UIImage(systemName: imageName)
        }
        
        myImageView.tintColor = UIColor(named: colorName)
        
        if type == "spend" {
            budgetLabel.textColor = UIColor(named: "Color30")
            budgetImageView.image = UIImage(named: "budgetgreen")
            amountLabel.textColor = .red
        } else {
            budgetLabel.textColor = .red
            budgetImageView.image = UIImage(named: "budgetred")
            amountLabel.textColor = UIColor(named: "Color30")
        }
        
        if budget > 0 {
            //budgetImageView.image = UIImage(named: "budget")
            budgetImageView.isHidden = false
            budgetLabel.text = String(format: "%.0f %@", locale: Locale.current, budget , globeCurrencyShortSymbol)

        } else {
            budgetImageView.isHidden = true
            
        }
        
        if amount > 0 {
            amountTitleLB.text = type == "spend" ? "chi tháng này" : "thu tháng này"
            amountLabel.text = (type == "spend" ? "-" : "+") + String(format: "%.0f %@", locale: Locale.current, amount , globeCurrencyShortSymbol)
            budgetPercentLB.text = budget > 0 ? String(format: "%.1f", 100*amount/budget) + "%" : ""
        } else {
            amountTitleLB.text = ""
            amountLabel.text = ""
            budgetPercentLB.text = ""
        }
        
        if editBtn {
            editButton.alpha = 1
        } else {
            editButton.alpha = 0
        }
        
        backView.reloadInputViews()
    }
    
    @IBAction func tapEditButton(_ sender: Any) {
        editButtonHandler?()
    }
    
}
