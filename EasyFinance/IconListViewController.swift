//
//  IconListViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 30/11/2022.
//

import UIKit

var iconList: [String] = ["airplane.circle.fill" , "annhahang" , "annhanh" , "annhau" , "ansang" , "antrua" , "anuongkhac" , "anvat" , "arrow.left.arrow.right.circle.fill" ,
                "arrow.left.circle.fill" , "arrow.right.circle.fill" , "arrowshape.turn.up.left.circle.fill" , "arrowshape.turn.up.right.circle.fill" ,
                "bag.circle.fill" , "banknote.fill" , "bicycle.circle.fill" , "bolt.heart.fill" , "bolt.slash.circle.fill" , "books.vertical.circle.fill" ,
                "building.columns.circle.fill" , "cabtv" , "cafe" , "calendar.badge.minus" , "calendar.badge.plus" , "camera.fill.badge.ellipsis" , "car.circle" ,
                "car.circle.fill" , "car.fill" , "cart.circle.fill" , "chart.line.uptrend.xyaxis.circle.fill" ,
                "command.circle.fill" , "creditcard.circle.fill" , "cross.circle.fill" , "diamond.circle.fill" , "dicho" , "dien" , "dienthoai" , "dollarsign.circle.fill" ,
                "dollarsign.circle.fill" , "figure.roll" , "figure.walk.circle.fill" , "film.circle.fill" , "fork.knife.circle.fill" , "fuelpump.circle" ,
                "gift.circle.fill" , "goidoan" , "graduationcap.circle" , "graduationcap.circle.fill" , "hare.fill" , "headphones.circle.fill" , "heart.circle" ,
                "heart.circle.fill" , "hourglass.circle.fill" , "house.circle.fill" , "larisign.circle.fill" , "leaf.circle.fill" , "lock.rectangle.on.rectangle.fill" ,
                "manatsign.circle.fill" , "mouth.fill" , "music.mic.circle.fill" , "net" , "nuoc" , "o.circle.fill" , "p.circle.fill" , "person.2.circle.fill" , "phicanho" ,
                "pills.circle.fill" , "power.circle.fill" , "r.circle.fill" , "snowflake.circle.fill" , "sportscourt.fill" , "suanha" , "sun.max.circle" ,
                "theatermasks.circle.fill" , "thuenha" , "tragopnha" , "tram.circle.fill" , "tshirt.fill" , "tv.circle.fill" , "wrench.and.screwdriver.fill"]

class IconListViewController: UIViewController {

    var selectedIndex: Int?
    @IBOutlet weak var iconImageView: UIImageView!
    var iconName: String = ""
    var colorName: String = ""
    var passData: (()-> Void)?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IconCollectionViewCell.nib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemGray6
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 8
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                            style: .plain, target: self,
                                                            action: #selector(saveAction))
        loadImage()
    }

    func loadImage() {
        if let img = UIImage(systemName: iconName) {
            iconImageView.image = img
        } else {
            iconImageView.image = UIImage(named: iconName)
        }
        iconImageView.tintColor = UIColor(named: colorName)
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.bounds.height/2
//        for i in 0..<iconList.count {
//            if iconList[i] == iconName {
//                selectedIndex = i
//                return
//            }
//        }
    }
    
    @objc func saveAction(_ sender: Any) {
       
        navigationController?.popViewController(animated: true)
        passData?()
    }
    
    
    @objc func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
}

extension IconListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as! IconCollectionViewCell
        cell.setData(iconName: iconList[indexPath.row])
  
        return cell
    }
    
}

extension IconListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 50)/6, height: (collectionView.bounds.height - 90)/10) //(collectionView.bounds.height - 70)/8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Select item \(indexPath.item) name: \(iconList[indexPath.item])")
        if selectedIndex != indexPath.item {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .red
            if selectedIndex != nil {
                collectionView.cellForItem(at: IndexPath(item: selectedIndex!, section: 0))!.backgroundColor = .white
            }
            selectedIndex = indexPath.item
            iconName = iconList[selectedIndex!]
            loadImage()
        }
    }
}
