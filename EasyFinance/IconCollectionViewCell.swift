//
//  IconCollectionViewCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 30/11/2022.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {

    static var identifier = "IconCollectionViewCell"
    
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "IconCollectionViewCell", bundle: nil)
    }

    func setData(iconName: String) {
        if let img = UIImage(named: iconName) {
            iconImageView.image = img.withRenderingMode(.alwaysOriginal)
        } else {
            iconImageView.image = UIImage(systemName: iconName)!.withRenderingMode(.alwaysOriginal)
        }
    }
}
