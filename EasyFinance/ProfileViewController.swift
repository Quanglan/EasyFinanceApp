//
//  ProfileViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import UIKit
import FirebaseAuth
import Toast_Swift

class ProfileViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var statusLB: UILabel!
    
    private let addTransactionBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(named: "Color30")
        let image = UIImage(systemName: "plus",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTabBarItemIndex = 4
        navigationItem.title = "Tài khoản của bạn"
        view.addSubview(addTransactionBtn)
        addTransactionBtn.addTarget(self, action: #selector(addTran), for: .touchUpInside)
        getUser()
        
        tapImageView()
    }
    
    @objc func addTran() {
        let vc = AddTranViewController()
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTransactionBtn.frame = CGRect(x: (view.frame.size.width - 60)/2,
                                         y: view.frame.size.height - 85, width: 60, height: 60)
    }
    
    func tapImageView() {
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionTapeImageView)))
    }
    
    @objc func actionTapeImageView() {
        let actionSheet = UIAlertController(title: .none,
                                            message: "Lựa chọn hình ảnh",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Huỷ",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Chụp ảnh",
                                            style: .default,
                                            handler: { _ in
            self.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Thư viện ảnh",
                                            style: .default,
                                            handler: { _ in
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
//       
//        .sourceType = .camera
//        vc.delegate = self
//        myImageView.allowsEditing = true
//        present(vc, animated: true)
    }
    
    func getUser() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let displayName = user.displayName
            let photoURL = user.photoURL
            
            statusLB.text = """
            uid: \(uid)
            email: \(email ?? "N/A")
            displayName: \(displayName ?? "N/A")
            photoURL: \(photoURL?.absoluteString ?? "N/A")
            """
        }
    }

    @IBAction func tapLogoutButton(_ sender: Any) {
        logOut()
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            routeToLogin()
        } catch let signOutError as NSError {
            self.view.makeToast(signOutError.localizedDescription)
        }
    }
    
    func routeToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = homeVC
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
