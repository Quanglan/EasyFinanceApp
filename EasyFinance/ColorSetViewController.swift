//
//  ColorSetViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import UIKit

class ColorSetViewController: UIViewController {

    @IBOutlet weak var color01Button: UIButton!
    @IBOutlet weak var color02Button: UIButton!
    @IBOutlet weak var color03Button: UIButton!
    @IBOutlet weak var color04Button: UIButton!
    @IBOutlet weak var color05Button: UIButton!
    @IBOutlet weak var color06Button: UIButton!
    @IBOutlet weak var color07Button: UIButton!
    @IBOutlet weak var color08Button: UIButton!
    @IBOutlet weak var color09Button: UIButton!
    @IBOutlet weak var color10Button: UIButton!
    @IBOutlet weak var color11Button: UIButton!
    @IBOutlet weak var color12Button: UIButton!
    @IBOutlet weak var color13Button: UIButton!
    @IBOutlet weak var color14Button: UIButton!
    @IBOutlet weak var color15Button: UIButton!
    @IBOutlet weak var color16Button: UIButton!
    @IBOutlet weak var color17Button: UIButton!
    @IBOutlet weak var color18Button: UIButton!
    @IBOutlet weak var color19Button: UIButton!
    @IBOutlet weak var color20Button: UIButton!
    @IBOutlet weak var color21Button: UIButton!
    @IBOutlet weak var color22Button: UIButton!
    @IBOutlet weak var color23Button: UIButton!
    @IBOutlet weak var color24Button: UIButton!
    @IBOutlet weak var color25Button: UIButton!
    @IBOutlet weak var color26Button: UIButton!
    @IBOutlet weak var color27Button: UIButton!
    @IBOutlet weak var color28Button: UIButton!
    @IBOutlet weak var color29Button: UIButton!
    @IBOutlet weak var color30Button: UIButton!
    @IBOutlet weak var color31Button: UIButton!
    @IBOutlet weak var color32Button: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
  
    @IBOutlet weak var imageView: UIImageView!
    var colorSetName: String = ""
    var imageName: String = ""
    var checkSave: Bool = false
    var passData: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
    }
    
    func setupImage() {
        saveButton.isEnabled = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.height/2
        if let image = UIImage(systemName: imageName) {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: imageName)
        }
        imageView.tintColor = UIColor(named: colorSetName)

    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        dismiss(animated: true)
        passData?()
    }
    
    @IBAction func tapColorSetButton(_ sender: UIButton) {
        saveButton.isEnabled = true
        colorSetName = sender.tag + 1 < 10 ? "Color0\(sender.tag + 1)" : "Color\(sender.tag + 1)"
        print(colorSetName)
        imageView.tintColor = UIColor(named: colorSetName)
        imageView.contentMode = .scaleAspectFit
    }
    
}
