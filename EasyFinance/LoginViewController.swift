//
//  LoginViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 12/11/2022.
//

import UIKit
import FirebaseAuth
import Toast_Swift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        emailTF.becomeFirstResponder()
        
        let cRadius: CGFloat = 12
        
        emailTF.layer.cornerRadius = cRadius
        emailTF.layer.masksToBounds = true
        emailTF.autocorrectionType = .no
        emailTF.autocapitalizationType = .none
        
        passwordTF.layer.cornerRadius = cRadius
        passwordTF.layer.masksToBounds = true
        passwordTF.autocorrectionType = .no
        passwordTF.autocapitalizationType = .none
        
        loginButton.layer.cornerRadius = cRadius
        loginButton.layer.masksToBounds = true
        
        registerButton.layer.cornerRadius = cRadius
        registerButton.layer.masksToBounds = true
        
    }
    
    func loginAction() {
        view.endEditing(true)
        if emailTF.text == "" || passwordTF.text == "" {
            self.view.makeToast("Xin mời nhập đủ thông tin")
        } else {
            let email = emailTF.text ?? ""
            let password = passwordTF.text ?? ""
            
            loginButton.isEnabled = false
            loginButton.setTitle("Loading...", for: .normal)
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                
                strongSelf.loginButton.isEnabled = true
                strongSelf.loginButton.setTitle("Đăng nhập", for: .normal)
                
                guard error == nil else {

                    strongSelf.view.makeToast(error?.localizedDescription)
                    return
                }
                
                authResult?.user.reload(completion: { error in
                    if (authResult?.user.isEmailVerified)! {
                        //Logi success
                        strongSelf.routeToMain()
                    } else {
                        strongSelf.view.makeToast("Email của bạn chưa được xác thực")
                    }
                })
                
            }
        }

    }
    
    @IBAction func tapLoginButton(_ sender: UIButton) {
        loginAction()
    
    }
    
    @IBAction func tapRegisterButton(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterVC")
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func tapForgetPassButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Quên mật khẩu", message: .none, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nhập địa chỉ email"
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: {_ in
            guard let filed = alert.textFields?.first, let email = filed.text, !email.isEmpty else {
                
                return
            }
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error != nil {
                    self.view.makeToast(error?.localizedDescription)
                } else {
                    self.view.makeToast("Kiểm tra email để đổi mật khẩu")
                }
            }
        }))
        present(alert, animated: true)
    }
    
    
    func routeToMain() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyBoard.instantiateViewController(withIdentifier: "MainVC")


        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = homeVC
        keyWindow?.makeKeyAndVisible()


    }
}

