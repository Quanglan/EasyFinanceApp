//
//  ItemListCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 26/11/2022.
//

import UIKit

class ItemListCell: UITableViewCell {

    static let identifier = "ItemListCell"
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textLB: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        backView.layer.cornerRadius = 12
//        backView.layer.shadowColor = UIColor.systemGray.cgColor
//        backView.layer.shadowOpacity = 1
//        backView.layer.shadowOffset = .zero //CGSize(width: 0, height: 0.5)
//        backView.layer.shadowRadius = 10
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.bounds.height/2
        checkButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ItemListCell", bundle: nil)
    }
    
    func setData(imageName: String, colorName: String, title: String) {
 
        textLB.text = title
        
        if let image = UIImage(named: imageName) {
            iconImageView.image = image
        } else {
            iconImageView.image = UIImage(systemName: imageName)
        }
        
        iconImageView.tintColor = UIColor(named: colorName)
    }
    
    func checkSelected(check: Bool) {
        if check {
            checkButton.isHidden = false
        } else {
            checkButton.isHidden = true
        }
    }
}
