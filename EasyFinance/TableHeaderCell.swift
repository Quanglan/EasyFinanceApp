//
//  TableHeaderCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 19/11/2022.
//

import UIKit

class TableHeaderCell: UITableViewCell {

    static let identifier = "TableHeaderCell"

    @IBOutlet weak var mytextLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var showDetailButton: UIButton!
    var tapShowDetailButton: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //backView.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 0.05)
//        backView.layer.masksToBounds = true
//        backView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TableHeaderCell", bundle: nil)
    }
    
    func setData(title: String, showButton: Bool) {
        mytextLabel.text = title
        if showButton {
            showDetailButton.isHidden = false
        } else {
            showDetailButton.isHidden = true
        }
    }
    
    @IBAction func showDetailPress(_ sender: Any) {
        tapShowDetailButton?()
    }
    
}
