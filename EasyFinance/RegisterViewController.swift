//
//  RegisterViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 12/11/2022.
//

import UIKit
import FirebaseAuth
import Toast_Swift

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Đăng ký"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backAction))
        setupView()
    }

    func setupView() {
        
        let cRadius: CGFloat = 12
        
        emailTF.layer.cornerRadius = cRadius
        emailTF.layer.masksToBounds = true
        emailTF.autocorrectionType = .no
        emailTF.autocapitalizationType = .none
        
        passwordTF.layer.cornerRadius = cRadius
        passwordTF.layer.masksToBounds = true
        passwordTF.autocorrectionType = .no
        passwordTF.autocapitalizationType = .none
        
        rePasswordTF.layer.cornerRadius = cRadius
        rePasswordTF.layer.masksToBounds = true
        rePasswordTF.autocorrectionType = .no
        rePasswordTF.autocapitalizationType = .none
        
        registerButton.layer.cornerRadius = cRadius
        registerButton.layer.masksToBounds = true
    }
    
    
    @IBAction func tapRegisterButton(_ sender: UIButton) {
        
        view.endEditing(true)
        if emailTF.text == "" || passwordTF.text == ""  || rePasswordTF.text == ""{
            self.view.makeToast("Xin mời nhập đủ thông tin")
            return
        }
        
        if passwordTF.text != rePasswordTF.text {
            self.view.makeToast("Gõ lại mật khẩu không chính xác")
            return
        }
        
        let email = emailTF.text ?? ""
         let password = passwordTF.text ?? ""
         
         registerButton.isEnabled = false
         registerButton.setTitle("Loading...", for: .normal)
         
         Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
             guard let strongSelf = self else { return }
             
             strongSelf.registerButton.isEnabled = true
             strongSelf.registerButton.setTitle("Register", for: .normal)
             
             guard error == nil else {
                 strongSelf.view.makeToast(error?.localizedDescription)
                 return
             }
 //            strongSelf.view.makeToast("Đăng ký thành công")
             
             authResult?.user.sendEmailVerification(completion: { error in
                 if error != nil {
                     strongSelf.view.makeToast(error?.localizedDescription)
                 } else {
                     strongSelf.view.makeToast("Đã gửi thư xác thực")
                     //strongSelf.routeToMain()
                     self!.backAction()
                 }
             })
            
         }
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func routeToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainVC")

        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first

        keyWindow?.rootViewController = homeVC
        keyWindow?.makeKeyAndVisible()
   
    }
}
